//
//  DataController.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 06/07/24.
//

import Foundation
import FirebaseDatabase

class DataController
{
    var books: [Book] = []
    
    static let shared = DataController() // singleton
    private let database = Database.database().reference()
    
    static func safeEmail(email: String) -> String {
            var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
    }
    
    func addAdmin(_ admin: Admin, completion: @escaping (Result<Void, Error>) -> Void) {
            let safeEmail = DataController.safeEmail(email: admin.email)
            
            // Check if the admin email already exists
            database.child("admins").child(safeEmail).observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    // Admin email already exists
                    completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Email is already in use."])))
                } else {
                    // Add the admin to the database
                    self.saveAdminToDatabase(admin) { result in
                        completion(result)
                    }
                }
            }
        }
        
        private func saveAdminToDatabase(_ admin: Admin, completion: @escaping (Result<Void, Error>) -> Void) {
            let safeEmail = DataController.safeEmail(email: admin.email)
            let adminDictionary = admin.toDictionary()
            database.child("admins").child(safeEmail).setValue(adminDictionary) { error, _ in
                if let error = error {
                    print("Failed to save admin: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Admin saved successfully.")
                    completion(.success(()))
                }
            }
        }
    
    
    
    func updateSubscriptionPrice(email: String, tierNumber: Int, monthlyPrice: String, yearlyPrice: String, completion: @escaping (Result<Void, Error>) -> Void) {
            let safeEmail = DataController.safeEmail(email: email)
            
            // Build the nested structure properly
            let subscriptionPath: String
            switch tierNumber {
            case 1:
                subscriptionPath = "bronzeSubscription"
            case 2:
                subscriptionPath = "silverSubscription"
            case 3:
                subscriptionPath = "goldSubscription"
            default:
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid tier number"])))
                return
            }
            
            let updatedProperties = [
                "\(subscriptionPath)/monthly": monthlyPrice,
                "\(subscriptionPath)/yearly": yearlyPrice
            ]
            
            database.child("admins").child(safeEmail).updateChildValues(updatedProperties) { error, _ in
                if let error = error {
                    print("Failed to update subscription price: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Subscription price updated successfully.")
                    completion(.success(()))
                }
            }
        }
    
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
            database.child("books").observe(.value) { snapshot in
                guard let booksDict = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                    return
                }
                
                var books: [Book] = []
                
                for (_, dict) in booksDict {
                    guard
                        let bookCode = dict["bookCode"] as? String,
                        let bookCover = dict["bookCover"] as? String,
                        let bookTitle = dict["bookTitle"] as? String,
                        let author = dict["author"] as? String,
                        let genreStrings = dict["genre"] as? [String],
                        let issuedDate = dict["issuedDate"] as? String,
                        let returnDate = dict["returnDate"] as? String,
                        let status = dict["status"] as? String
                    else {
                        print("Failed to parse book data.")
                        continue
                    }
                    
                    // Convert genre strings to Genre enum array
                    let genres = genreStrings.compactMap { Genre(rawValue: $0) }
                    
                    let book = Book(
                        bookCode: bookCode,
                        bookCover: bookCover,
                        bookTitle: bookTitle,
                        author: author,
                        genre: genres,
                        issuedDate: issuedDate,
                        returnDate: returnDate,
                        status: status
                    )
                    
                    books.append(book)
                }
                
                print("Fetched \(books.count) books.")
                completion(.success(books))
            }
        }
    }
