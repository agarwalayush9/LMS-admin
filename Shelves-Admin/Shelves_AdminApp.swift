//
//  Shelves_AdminApp.swift
//  Shelves-Admin
//
//  Created by Ayush Agarwal on 03/07/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Shelves_AdminApp: App {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        
        WindowGroup {
            if isLoggedIn {
                        AdminDashboard(isLoggedIn: $isLoggedIn)
                    } else {
                        AdminLoginView(isLoggedIn: $isLoggedIn)
                    }
        }
       
    }
}
