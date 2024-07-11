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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager() // Use @StateObject for SwiftUI 2.0
    
    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                AdminDashboard()
                    .environmentObject(authManager)
            } else {
                AdminLoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
