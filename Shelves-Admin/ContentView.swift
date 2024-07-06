//
//  ContentView.swift
//  Shelves-Admin
//
//  Created by Ayush Agarwal on 03/07/24.
//

import SwiftUI
import FirebaseAuth

struct AdminLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    

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
                
                HStack{
                    Image("App Logo")
                    .frame(width: 36.75, height: 37.5)
                    
                    Text("Shelves")
                    .font(
                    Font.custom("DMSans-Bold", size: 30)
                        
                    )
                    .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                }
                
                Text("Admin Log in")
                .font(
                Font.custom("DM Sans", size: 36)
                .weight(.bold)
                )
                .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))

                .frame(maxWidth: 400, alignment: .topLeading)
                
                Text("Welcome back Admin! Please enter your details.")
                    .font(Font.custom("DMSans_18pt-Regular", size: 19))
                .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06)
                    )
                .frame(maxWidth: 410, alignment: .topLeading)
                
                


                Text("Email")
                    
                    .font(Font.custom("DMSans_18pt-Regular", size: 15))
                .frame(maxWidth: 400, alignment: .topLeading)
                // Email Field
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8) // Adds rounded corners to the background
                    .overlay(
                            RoundedRectangle(
                                cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                                        )
                        .frame(width: 300)
                
                
                Text("Password")
                    
                    .font(Font.custom("DMSans_18pt-Regular", size: 15))
                .frame(maxWidth: 400, alignment: .topLeading)
                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8) // Adds rounded corners to the background
                    .overlay(
                            RoundedRectangle(
                                cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                                        )
                        .frame(width: 300)
                    
                
                
                  
                    
                    
                    
                Spacer().frame(height: 8)
                    
                
                
                // Sign in Button
                Button(action: {
                    // Sign in action
                    login()
                    
                }) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                        .cornerRadius(8)
                        .frame(width: 300)
                }
                Button(action: {
                    // Forgot password action
                }) {
                    Text("Forgot password")
                        .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                        .frame(maxWidth: 300, alignment: .center)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        
        
        
    }
    
    func login()
    {
        Auth.auth().signIn(withEmail: email, password: password){
            firebaseResult, error in
            if error != nil {
                print("Invalid Password")
               
            }
            else {
                
            }
        }
    }
    
    func register()
    {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            }
            else {
                print("User signed up successfully")
            }
        }
    }
    
}



    


// Custom toggle style for the checkbox
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
    
}

struct ContentView: View {
    

    var body: some View {
        AdminLoginView()
    }
}

#Preview {
    ContentView()
}
