import SwiftUI
import FirebaseAuth

struct AdminLoginView: View {
    @EnvironmentObject var authManager: AuthManager // Inject AuthManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var emailValidationMessage: String = ""
    @State private var passwordValidationMessage: String = ""
    @State private var isEmailValid: Bool = false
    @State private var isPasswordValid: Bool = false
    @State private var passwordLengthValid: Bool = false
    @State private var passwordUppercaseValid: Bool = false
    @State private var passwordLowercaseValid: Bool = false
    @State private var passwordNumberValid: Bool = false
    @State private var passwordSpecialCharValid: Bool = false
    @State private var resetpassword = false
    @State private var resetAlert: String = ""
    @State private var isLoading = false
    
    var body: some View {
        HStack(alignment: .center) {
            
            // Left side illustration
            VStack {
                Spacer()
                    
                Image("adminVector") // Your illustration image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                Spacer()
            }
            .frame(maxWidth: .infinity)

            // Right side login form
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                HStack {
                    Image("App Logo")
                        .frame(width: 36.75, height: 37.5)
                    
                    Text("Shelves")
                        .font(Font.custom("DMSans-Bold", size: 30))
                        .foregroundColor(Color.login)
                }
                
                if(!resetpassword){
                    Text("Admin Log in")
                        .font(Font.custom("DM Sans", size: 36).weight(.bold))
                        .foregroundColor(Color.login)
                        .frame(maxWidth: 400, alignment: .topLeading)
                    
                    Text("Welcome back Admin! Please enter your details.")
                        .font(Font.custom("DMSans_18pt-Regular", size: 19))
                        .foregroundColor(Color.login)
                        .frame(maxWidth: 410, alignment: .topLeading)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(Font.custom("DMSans_18pt-Regular", size: 15))
                        
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(Color.adminDashboardBg)
                            .cornerRadius(8) // Adds rounded corners to the background
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.mainFont, lineWidth: 1)
                            )
                            .frame(width: 300)
                            .onChange(of: email) { _ in
                                validateEmail()
                            }
                        
                        Text(emailValidationMessage)
                            .foregroundColor(isEmailValid ? .green : .red)
                            .font(Font.custom("DMSans_18pt-Regular", size: 12))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password")
                            .font(Font.custom("DMSans_18pt-Regular", size: 15))
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.adminDashboardBg)
                            .cornerRadius(8) // Adds rounded corners to the background
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.mainFont, lineWidth: 1)
                            )
                            .frame(width: 300)
                            .onChange(of: password) { _ in
                                validatePassword()
                            }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Image(systemName: passwordLengthValid ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(passwordLengthValid ? .green : .red)
                                Text("Your password must be at least 8 characters long")
                                    .foregroundColor(passwordLengthValid ? .green : .red)
                                    .font(Font.custom("DMSans_18pt-Regular", size: 12))
                            }
                            HStack {
                                Image(systemName: passwordUppercaseValid ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(passwordUppercaseValid ? .green : .red)
                                Text("1 uppercase letter")
                                    .foregroundColor(passwordUppercaseValid ? .green : .red)
                                    .font(Font.custom("DMSans_18pt-Regular", size: 12))
                            }
                            HStack {
                                Image(systemName: passwordLowercaseValid ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(passwordLowercaseValid ? .green : .red)
                                Text("1 lowercase letter")
                                    .foregroundColor(passwordLowercaseValid ? .green : .red)
                                    .font(Font.custom("DMSans_18pt-Regular", size: 12))
                            }
                            HStack {
                                Image(systemName: passwordNumberValid ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(passwordNumberValid ? .green : .red)
                                Text("1 number")
                                    .foregroundColor(passwordNumberValid ? .green : .red)
                                    .font(Font.custom("DMSans_18pt-Regular", size: 12))
                            }
                            HStack {
                                Image(systemName: passwordSpecialCharValid ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(passwordSpecialCharValid ? .green : .red)
                                Text("1 special character")
                                    .foregroundColor(passwordSpecialCharValid ? .green : .red)
                                    .font(Font.custom("DMSans_18pt-Regular", size: 12))
                            }
                        }
                    }
                    
                    Spacer().frame(height: 8)
                    
                    // Sign in Button
                    Button(action: {
                        // Sign in action
                        login()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                                .cornerRadius(8)
                                .frame(width: 300)
                        } else {
                            Text("Sign in")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                                .cornerRadius(8)
                                .frame(width: 300)
                        }
                    }
                    .disabled(!isEmailValid || !isPasswordValid)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Invalid Credentials"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    Button(action: {
                        // Forgot password action
                        resetpassword.toggle()
                    }) {
                        Text("Forgot password?")
                            .foregroundColor(Color.login)
                            .frame(maxWidth: 300, alignment: .center)
                    }
                    
                    Spacer()
                }
                else{
                    Text("Password Reset")
                        .font(Font.custom("DM Sans", size: 36).weight(.bold))
                        .foregroundColor(Color.login)
                        .frame(maxWidth: 400, alignment: .topLeading)
                    
                    Text("Enter your existing Email Id")
                        .font(Font.custom("DMSans_18pt-Regular", size: 19))
                        .foregroundColor(Color.login)
                        .frame(maxWidth: 410, alignment: .topLeading)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(Font.custom("DMSans_18pt-Regular", size: 15))
                        
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(Color.adminDashboardBg)
                            .cornerRadius(8) // Adds rounded corners to the background
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.mainFont, lineWidth: 1)
                            )
                            .frame(width: 300)
                            .onChange(of: email) { _ in
                                validateEmail()
                            }
                        
                        Text(emailValidationMessage)
                            .foregroundColor(isEmailValid ? .green : .red)
                            .font(Font.custom("DMSans_18pt-Regular", size: 12))
                    }
                    
                    // Sign in Button
                    Button(action: {
                        // Reset password action
                        resetMail()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                                .cornerRadius(8)
                                .frame(width: 300)
                        } else {
                            Text("Reset Password")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                                .cornerRadius(8)
                                .frame(width: 300)
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(resetAlert), dismissButton: .default(Text("OK")))
                    }
                    
                    Button(action: {
                        // Back to sign in action
                        resetpassword.toggle()
                    }) {
                        Text("Back to sign in")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.gray)
                            .cornerRadius(8)
                            .frame(width: 300)
                    }
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
    
    func validateEmail() {
        if email.isEmpty {
            emailValidationMessage = "Email cannot be empty"
            isEmailValid = false
        } else if !isValidEmailFormat(email) {
            emailValidationMessage = "Invalid email format."
            isEmailValid = false
        } else if hasConsecutiveDots(email) {
            emailValidationMessage = "Email contains consecutive dots."
            isEmailValid = false
        } else if startsOrEndsWithDot(email) {
            emailValidationMessage = "Email starts or ends with a dot."
            isEmailValid = false
        } else if hasCapitalizedDomain(email) {
            emailValidationMessage = "Email domain should be lowercase."
            isEmailValid = false
        } else {
            emailValidationMessage = "Email is valid."
            isEmailValid = true
        }
    }

    func validatePassword() {
        let passwordRegex = [
            ("^(?=.*[A-Z]).{1,}$", $passwordUppercaseValid), // Uppercase letter
            ("^(?=.*[a-z]).{1,}$", $passwordLowercaseValid), // Lowercase letter
            ("^(?=.*\\d).{1,}$", $passwordNumberValid), // Digit
            ("^(?=.*[#$^+=!*()@%&]).{1,}$", $passwordSpecialCharValid), // Special character
            (".{8,}", $passwordLengthValid) // Length of at least 8
        ]
        
        for (regex, validation) in passwordRegex {
            let pred = NSPredicate(format: "SELF MATCHES %@", regex)
            validation.wrappedValue = pred.evaluate(with: password)
        }
        
        isPasswordValid = passwordLengthValid && passwordUppercaseValid && passwordLowercaseValid && passwordNumberValid && passwordSpecialCharValid
    }
    
    func isValidEmailFormat(_ email: String) -> Bool {
        if email.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!$%&'*+/=?^`{|}~-]+(?:\\.[\\p{L}0-9!$%&'*+/=?^`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}]{2,}|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }


    func hasConsecutiveDots(_ email: String) -> Bool {
        return email.contains("..")
    }

    func startsOrEndsWithDot(_ email: String) -> Bool {
        return email.hasPrefix(".") || email.hasSuffix(".")
    }

    func hasCapitalizedDomain(_ email: String) -> Bool {
        guard let atIndex = email.firstIndex(of: "@") else {
            return false
        }
        
        let domainPart = String(email.suffix(from: atIndex))
        return domainPart != domainPart.lowercased()
    }

    func login() {
        isLoading = true
        authManager.signIn(email: email, password: password) { result in
            isLoading = false
            switch result {
            case .success:
                print("Login successful")
                // Do any additional UI updates or navigation here
            case .failure(let error):
                errorMessage = error.localizedDescription
                showAlert = true
                print(error.localizedDescription)
            }
        }
    }
    
    func resetMail() {
        isLoading = true
        authManager.resetPassword(email: email) { result in
            isLoading = false
            switch result {
            case .success(let message):
                resetAlert = message
                showAlert = true
                print(message)
            case .failure(let error):
                resetAlert = error.localizedDescription
                showAlert = true
                print(error.localizedDescription)
            }
        }
    }
}
#Preview {
    AdminLoginView()
}
