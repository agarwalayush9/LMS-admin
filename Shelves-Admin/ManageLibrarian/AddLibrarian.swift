import SwiftUI
import Firebase
import FirebaseDatabase
import Combine
import FirebaseAuth


struct Constants {
    static let BackgroundsGroupedPrimary: Color = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let MiscellaneousBarBorder: Color = .black.opacity(0.0)
    static let sm: CGFloat = 12
    static let xxs: CGFloat = 8
    static let LabelsPrimary: Color = .black
    static let xs: CGFloat = 10
    static let `default`: CGFloat = 16
    static let ColorsBlue: Color = Color(red: 0, green: 0.48, blue: 1)
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
}

struct Config {
    static var sendGridAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
            fatalError("Couldn't find file 'config.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "SENDGRID_API_KEY") as? String else {
            fatalError("Couldn't find key 'SENDGRID_API_KEY' in 'config.plist'.")
        }
        return value
    }
}

struct Librarian {
    let name: String
    let phoneNumber: String
    var status: String
    let email: String
    let userId: String
    let password: String
}

struct LibrarianCard: View {
    var librarian: Librarian
    @Binding var selectedLibrarian: Librarian?
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.xxs) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 110, height: 110)
                .background(
                    Image(systemName: "person.crop.circle")
                        .resizable().foregroundColor(.addLiberian)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110)
                        .clipped()
                )
                .cornerRadius(110)
            Text(librarian.name)
                .font(Font.custom("DM Sans", size: 20).weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
            Text(librarian.phoneNumber)
                .font(Font.custom("DM Sans", size: 20).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
            Button(action: {
                selectedLibrarian = librarian
                showSheet = true
            }) {
                Text(librarian.status)
                    .font(Font.custom("DM Sans", size: 16).weight(.bold))
                    .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                    .frame(width: 140, height: 25)
                    .padding(.horizontal, Constants.default)
                    .padding(.vertical, 7)
                    .background(Color(red: 1, green: 0.74, blue: 0.28))
                    .cornerRadius(61)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 25)
        .frame(width: 195, alignment: .center)
        .cornerRadius(Constants.xxs)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.xxs)
                .inset(by: 1.5)
                .stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3)
        )
    }
}

struct AddLibrarian: View {
    @StateObject private var viewModel = LibrarianViewModel()
    @State private var selectedLibrarian: Librarian?
    @State private var showSheet = false
    @State var menuOpened = false

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView()
                    .ignoresSafeArea(.all)
                backgroundView()
                    .ignoresSafeArea(.all)
                    .blur(radius: menuOpened ? 10 : 0)
                    .animation(.easeInOut(duration: 0.25), value: menuOpened)

                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("Manage Librarians")
                                .font(Font.custom("DM Sans", size: 48).weight(.medium))
                                .foregroundColor(.black)
                                .padding(.top, 15)
                                .padding(.leading, 64)
                                .padding(.bottom, 20)
                            Spacer()
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView("Loading Librarians...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(viewModel.librarians, id: \.email) { librarian in
                                    LibrarianCard(librarian: librarian, selectedLibrarian: $selectedLibrarian, showSheet: $showSheet)
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 25)

                        Spacer()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 19))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Constants.BackgroundsGroupedPrimary)
                .sheet(isPresented: Binding(
                    get: { showSheet },
                    set: { showSheet = $0 }
                )) {
                    if let selectedLibrarian = selectedLibrarian {
                        LibrarianDetailView(librarian: selectedLibrarian, showSheet: $showSheet)
                    }
                }

                if menuOpened {
                    sideMenu(width: UIScreen.main.bounds.width * 0.30, menuOpened: menuOpened, toggleMenu: toggleMenu)
                        .ignoresSafeArea()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
            .navigationTitle("LMS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        menuOpened.toggle()
                    }, label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.mainFont)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.fetchLibrarians()  // Call fetchLibrarians to refresh the data
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color.mainFont)
                    })
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func toggleMenu() {
        menuOpened.toggle()
    }
}



struct LibrarianDetailView: View {
    var librarian: Librarian
    @Binding var showSheet: Bool
    @State private var inviteSent = false
    @State private var credentialsGenerated = false
    @State private var userId: String
    @State private var password: String
    @State private var updatedLibrarian: Librarian
    @State private var showAlert = false
    
    init(librarian: Librarian, showSheet: Binding<Bool>) {
        self.librarian = librarian
        self._showSheet = showSheet
        self._updatedLibrarian = State(initialValue: librarian)
        self.userId = librarian.userId
        self.password = librarian.password
    }

    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSheet = false
                    }) {
                        Text("Cancel")
                            .font(Font.custom("DM Sans", size: 17))
                            .foregroundColor(Constants.ColorsBlue)
                    }
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
                
                VStack(alignment: .leading, spacing: 40) {
                    Text("Librarian Details")
                        .font(Font.custom("DM Sans", size: 32).weight(.bold))
                        .foregroundColor(.mainFont)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    HStack(alignment: .center, spacing: 59) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 200, height: 200)
                            .background(
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipped()
                            )
                            .cornerRadius(200)
                        
                        VStack(alignment: .leading, spacing: 13) {
                            Text("Name")
                                .font(Font.custom("DM Sans", size: 12).weight(.bold))
                                .foregroundColor(.mainFont)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(librarian.name)
                                .font(Font.custom("DM Sans", size: 24).weight(.bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.mainFont)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text("Email")
                                .font(Font.custom("DM Sans", size: 12).weight(.bold))
                                .foregroundColor(.mainFont)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(librarian.email)
                                .foregroundColor(.mainFont)
                                .font(Font.custom("DM Sans", size: 24).weight(.bold))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text("Phone Number")
                                .font(Font.custom("DM Sans", size: 12).weight(.bold))
                                .foregroundColor(.mainFont)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(librarian.phoneNumber)
                                .font(Font.custom("DM Sans", size: 24).weight(.bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.mainFont)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                        .padding(0)
                        .frame(width: 315, alignment: .topLeading)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    if !inviteSent {
                        VStack {
                            HStack(alignment: .center, spacing: 125) {
                                Text("Credentials")
                                    .font(Font.custom("DM Sans", size: 32).weight(.bold))
                                    .foregroundColor(.mainFont)
                                if librarian.status != "Approved"{
                                    HStack(alignment: .center, spacing: 9.89926) {
                                        Image("Traced Image 1")
                                            .frame(width: Constants.xl, height: 23.625)
                                        Text("Generate Credentials")
                                            .font(Font.custom("DM Sans", size: 16).weight(.bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, Constants.lg)
                                    .padding(.vertical, Constants.sm)
                                    .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                                    .cornerRadius(Constants.xxs)
                                    .frame(alignment: .bottomTrailing)
                                    .onTapGesture {
                                        generateCredentials()
                                    }
                                }
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            
                            VStack(alignment: .leading, spacing: Constants.sm) {
                                VStack(alignment: .leading, spacing: Constants.xxs) {
                                    Text("User ID")
                                        .font(Font.custom("DM Sans", size: 12).weight(.bold))
                                        .foregroundColor(.mainFont)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    HStack(alignment: .center, spacing: Constants.xs) {
                                        Text(userId)
                                            .font(Font.custom("DM Sans", size: 24).weight(.bold))
                                            .foregroundColor(.mainFont)
                                    }
                                    .padding(.horizontal, 44)
                                    .padding(.vertical, Constants.lg)
                                    .frame(width: 396, alignment: .center)
                                    .cornerRadius(9)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .inset(by: 1)
                                            .stroke(Color(red: 0.32, green: 0.23, blue: 0.06), lineWidth: 2)
                                    )
                                }
                                .padding(0)
                                .padding(.top, 5)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                
                                VStack(alignment: .leading, spacing: Constants.xxs) {
                                    Text("Password")
                                        .font(Font.custom("DM Sans", size: 12).weight(.bold))
                                        .foregroundColor(.mainFont)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    HStack(alignment: .center, spacing: Constants.xs) {
                                        Text(password)
                                            .font(Font.custom("DM Sans", size: 24).weight(.bold))
                                            .foregroundColor(.mainFont)
                                    }
                                    .padding(.horizontal, 44)
                                    .padding(.vertical, Constants.lg)
                                    .frame(width: 396, alignment: .center)
                                    .cornerRadius(9)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .inset(by: 1)
                                            .stroke(Color(red: 0.32, green: 0.23, blue: 0.06), lineWidth: 2)
                                    )
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            HStack(spacing: 20) {
                                HStack(alignment: .center, spacing: 9.89926) {
                                    if librarian.status != "Approved" {
                                        Image("mdi_invite")
                                            .frame(width: Constants.xl, height: Constants.xl)
                                        Text("Invite Librarian")
                                            .font(Font.custom("DM Sans", size: 16).weight(.bold))
                                            .foregroundColor(.white)
                                    } else {
                                        Image(systemName: "arrow.circlepath")
                                            .frame(width: Constants.xl, height: Constants.xl)
                                            .foregroundColor(.white)
                                        Text("Resend Invite")
                                            .font(Font.custom("DM Sans", size: 16).weight(.bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, Constants.lg)
                                .padding(.vertical, Constants.sm)
                                .background(credentialsGenerated || librarian.status == "Approved" ? Color(red: 0.32, green: 0.23, blue: 0.06) : Color.gray)
                                .cornerRadius(Constants.xxs)
                                .padding(.top, 15)
                                .onTapGesture {
                                    if (credentialsGenerated) && (librarian.status != "Approved") {
                                        inviteLibrarian()
                                    } else {
                                        inviteMail()
                                    }
                                }
                                
                                if librarian.status != "Approved" {
                                    Button(action: {
                                        showAlert = true
                                    }) {
                                        Image(systemName: "person.fill.badge.minus")
                                            .frame(width: Constants.xl, height: Constants.xl)
                                            .foregroundColor(.white)
                                        Text("Reject")
                                            .font(Font.custom("DM Sans", size: 16).weight(.bold))
                                            .foregroundColor(.white)
                                    }
                                    .alert(isPresented: $showAlert, content: {
                                        Alert(
                                                title: Text("Are you sure?"),
                                                message: Text("The details will be deletd"),
                                                primaryButton: .default(Text("No")),
                                                secondaryButton: .destructive(Text("Delete"), action: {
                                                 rejectLibrarian()
                                                 showSheet = false
                                                })
                                              )
                                    })
                                    .padding(.horizontal, Constants.lg)
                                    .padding(.vertical, Constants.sm)
                                    .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                                    .cornerRadius(Constants.xxs)
                                    .padding(.top, 15)
                                } else {
                                    Button(action: {
                                        showAlert = true
                                    }) {
                                        Image(systemName: "person.crop.circle.fill.badge.minus")
                                            .frame(width: Constants.xl, height: Constants.xl)
                                            .foregroundColor(.white)
                                        Text("Suspend")
                                            .font(Font.custom("DM Sans", size: 16).weight(.bold))
                                            .foregroundColor(.white)
                                    }
                                    .alert(isPresented: $showAlert, content: {
                                        Alert(
                                                title: Text("Are you sure?"),
                                                message: Text("Restrict librarian access to the portal"),
                                                primaryButton: .default(Text("No")),
                                                secondaryButton: .destructive(Text("Suspend"), action: {
                                                suspendLibrarian()
                                                 showSheet = false
                                                })
                                              )
                                    })
                                    .padding(.horizontal, Constants.lg)
                                    .padding(.vertical, Constants.sm)
                                    .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                                    .cornerRadius(Constants.xxs)
                                    .padding(.top, 15)
                                }
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Image("mingcute_mail-line")
                                .frame(width: 92, height: 92)
                                .cornerRadius(50)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.top, 45)
                        HStack {
                            Spacer()
                            Text("Invitation sent to the librarian's email")
                                .font(
                                    Font.custom("DM Sans", size: 32)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.mainFont)
                                .frame(width: 398, alignment: .top)
                            Spacer()
                        }
                    }
                }
                .frame(width: 614.89929, alignment: .topLeading)
                Spacer()
            }
        }
    }

    private func generateCredentials() {
        if let emailPrefix = librarian.email.split(separator: "@").first {
            userId = String(emailPrefix)
        }
        let passwordString = String((0..<6).map { _ in "0123456789".randomElement()! })
        password = (librarian.name).replacingOccurrences(of: " ", with: ".") + "@" + passwordString
        credentialsGenerated = true
    }
    
    private func inviteLibrarian() {
        // Generate credentials if not already generated
        if !credentialsGenerated {
            generateCredentials()
        }
        // Update the librarian's status locally
        updatedLibrarian.status = "Approved"
        
        // Format email into a Firebase-compatible key
        let sanitizedEmail = formatFirebaseKey(librarian.email)

        // Update Firebase database with the new status and credentials
        let ref = Database.database().reference().child("users").child(sanitizedEmail)
        let librarianData: [String: Any] = [
            "status": updatedLibrarian.status,
            "userId": userId,
            "password": password
        ]
        
        ref.updateChildValues(librarianData) { error, _ in
            if let error = error {
                print("Error updating status and credentials: \(error.localizedDescription)")
            } else {
                print("Status and credentials updated successfully")
            }
        }
        // mail triggering
        inviteMail()
    }

    private func inviteMail() {
        let email = "shelves@outlook.in"
        let json: [String: Any] = [
            "personalizations": [
                ["to": [["email": librarian.email]]]
            ],
            "from": ["email": email],
            "subject": "Welcome to Shelves Library",
            "content": [
                ["type": "text/html", "value": """
                          <!DOCTYPE html>
                          <html>
                          <head>
                              <style>
                                  .email-container {
                                      font-family: Arial, sans-serif;
                                      line-height: 1.6;
                                      color: #8A682A;
                                      background-image: linear-gradient(rgba(242, 197, 118, 0.7), rgba(242, 197, 118, 0.7)), url('https://github.com/suraj0209/email-cover/blob/main/E810223C-730B-4EE2-AF21-FC4EF9104BC9.jpg?raw=true'); /* Gradient over background image */
                                      padding: 20px;
                                      background-size: cover;
                                      background-blend-mode: overlay;
                                  }
                                  .overlay {
                                      background-color: rgba(255, 255, 255, 0.5); /* White background with 50% opacity */
                                      padding: 20px;
                                      border-radius: 10px;
                                  }
                                  .header, .content, .footer {
                                      padding: 10px;
                                  }
                                  .logo-container {
                                      display: flex;
                                      align-items: center; /* Align items vertically */
                                      justify-content: center;
                                      gap: 20px; /* Custom padding between images */
                                  }
                                  .header img.logo {
                                      height: 40px; /* Custom height for logo */
                                      vertical-align: bottom; /* Align images to the bottom */
                                  }
                                  .header img.app-name {
                                      height: 30px; /* Custom height for app name */
                                      vertical-align: bottom; /* Align images to the bottom */
                                      margin-top: 10px; /* Add a margin to align the app name slightly down */
                                              margin-left: 5px;
                                  }
                                  .header h1 {
                                      line-height: 1.2; /* Reduce line height to reduce padding between lines */
                                  }
                                  .content h2, .content h3, .content h4, .content p, .footer p {
                                      color: #8A682A; /* Ensure text color remains consistent */
                                  }
                              </style>
                          </head>
                          <body>
                              <div class="email-container">
                                  <div class="overlay">
                                      <div class="header">
                                          <div class="logo-container">
                                              <img src="https://github.com/suraj0209/email-cover/blob/main/Group%201.png?raw=true" alt="Logo" class="logo">
                                              <img src="https://github.com/suraj0209/email-cover/blob/main/Shelves..png?raw=true" alt="App Name" class="app-name">
                                          </div>
                                          <h1>Welcome to Shelves library!</h1>
                                      </div>
                                      <div class="content">
                                          <h2>The login credentials are</h2>
                                          <h3>Email Id: \(librarian.email)</h3>
                                          <h4>Password: \(librarian.password)</h4>
                                          <p>Best regards,<br>Shelves</p>
                                      </div>
                                      <div class="footer">
                                          <p>&copy; 2024 Shelves App. All rights reserved.</p>
                                      </div>
                                  </div>
                              </div>
                          </body>
                          </html>
                    """]
            ]
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let request: URLRequest = {
            let apiKey = Config.sendGridAPIKey
            let url = URL(string: "https://api.sendgrid.com/v3/mail/send")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            return request
        }()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending email: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
                inviteSent = true
                print("Email sent successfully")
                if librarian.status != "Approved"{
                    Auth.auth().createUser(withEmail: librarian.email, password: password) { authResult, error in
                        if let error = error {
                            print("Error creating user: \(error.localizedDescription)")
                        } else {
                            print("User created successfully: \(authResult?.user.uid ?? "Unknown UID")")
                            print("Password -\(password)")
                        }
                    }
                }
            } else {
                print("Failed to send email")
            }
        }.resume()
    }
    private func suspendMail(){
        let email = "shelves@outlook.in"
        let json: [String: Any] = [
            "personalizations": [
                ["to": [["email": librarian.email]]]
            ],
            "from": ["email": email],
            "subject": "Shelves Library Account Update",
            "content": [
                ["type": "text/plain", "value": """
                    Dear \(librarian.name),

                    This email informs you that your account has been suspended by the administrative team.We understand this may be inconvenient, and we apologize for any disruption this may cause.
                    
                    For further clarification regarding the suspension and potential reinstatement, please contact us at shelves@outlook.in.

                    Sincerely,
                    Admin
                    Shelves Library Team
                    """]
            ]
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let request: URLRequest = {
            let apiKey = Config.sendGridAPIKey
            let url = URL(string: "https://api.sendgrid.com/v3/mail/send")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            return request
        }()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending email: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
               
                print("Email sent successfully")
               
            } else {
                print("Failed to send email")
            }
        }.resume()
    }

    private func formatFirebaseKey(_ email: String) -> String {
        // Replace @ with empty string and . with hyphen
        return email.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }

    private func rejectLibrarian() {
        let sanitizedEmail = formatFirebaseKey(librarian.email)
        let ref = Database.database().reference().child("users").child(sanitizedEmail)
        ref.removeValue()
    }

    private func suspendLibrarian() {
        updatedLibrarian.status = "Suspended"
        updateLibrarianStatusInFirebase()
        suspendMail()
    }

    private func updateLibrarianStatusInFirebase() {
        let sanitizedEmail = formatFirebaseKey(librarian.email)
        let ref = Database.database().reference().child("users").child(sanitizedEmail)
        let librarianData: [String: Any] = [
            "status": updatedLibrarian.status,
        ]
        
        ref.updateChildValues(librarianData) { error, _ in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
            } else {
                print("Status updated successfully")
            }
        }
    }
}





    #Preview(){
        AddLibrarian()
    }
