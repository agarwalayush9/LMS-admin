import Foundation
import FirebaseDatabase
import Combine

class LibrarianViewModel: ObservableObject {
    @Published var librarians: [Librarian] = []

    private var databaseRef: DatabaseReference!

    init() {
        databaseRef = Database.database().reference().child("users")
        fetchLibrarians()
    }

    func fetchLibrarians() {
        databaseRef.observe(.value, with: { snapshot in
            var newLibrarians: [Librarian] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let name = dict["name"] as? String,
                   let status = dict["status"] as? String,
                   let userId = dict["userId"] as? String,
                   let password = dict["password"] as? String,
                   let phoneNumber = dict["phoneNumber"] as? Int,
                   let email = dict["email"] as? String {
                    let librarian = Librarian(name: name, phoneNumber: "\(phoneNumber)", status: status, email: email, userId: userId, password: password)
                    newLibrarians.append(librarian)
                } else {
                    print("Failed to parse child snapshot: \(child)")
                }
            }

            self.librarians = newLibrarians
//            print("Fetched librarians: \(self.librarians)")
        }) { error in
            print("Failed to fetch data from Firebase: \(error.localizedDescription)")
        }
    }
}
