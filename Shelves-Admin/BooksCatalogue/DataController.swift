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
    
   
   
    
    
    
    func addBronzeSubscription(_ subscription: BronzeSubscription, completion: @escaping (Result<Void, Error>) -> Void) {
            // Save bronze subscription to Firebase
            let subscriptionDictionary = subscription.toDictionary()
            database.child("subscriptions").child("bronze").setValue(subscriptionDictionary) { error, _ in
                if let error = error {
                    print("Failed to save bronze subscription: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Bronze subscription saved successfully.")
                    completion(.success(()))
                }
            }
        }
        
        func addSilverSubscription(_ subscription: SilverSubscription, completion: @escaping (Result<Void, Error>) -> Void) {
            // Save silver subscription to Firebase
            let subscriptionDictionary = subscription.toDictionary()
            database.child("subscriptions").child("silver").setValue(subscriptionDictionary) { error, _ in
                if let error = error {
                    print("Failed to save silver subscription: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Silver subscription saved successfully.")
                    completion(.success(()))
                }
            }
        }
        
        func addGoldSubscription(_ subscription: GoldSubscription, completion: @escaping (Result<Void, Error>) -> Void) {
            // Save gold subscription to Firebase
            let subscriptionDictionary = subscription.toDictionary()
            database.child("subscriptions").child("gold").setValue(subscriptionDictionary) { error, _ in
                if let error = error {
                    print("Failed to save gold subscription: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Gold subscription saved successfully.")
                    completion(.success(()))
                }
            }
        }
    
    
    
    
    func updateBronzeSubscription(monthly: Int, yearly: Int, activeUsers: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            let updatedProperties: [String: Any] = [
                "monthly": monthly,
                "yearly": yearly,
                "activeUsers": activeUsers
            ]
            
            database.child("subscriptions").child("bronze").updateChildValues(updatedProperties) { error, _ in
                if let error = error {
                    print("Failed to update bronze subscription: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Bronze subscription updated successfully.")
                    completion(.success(()))
                }
            }
        }
        
        func updateSilverSubscription(monthly: Int, yearly: Int, activeUser: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            let updatedProperties: [String: Any] = [
                "monthly": monthly,
                "yearly": yearly,
                "activeUser": activeUser
            ]
            
            database.child("subscriptions").child("silver").updateChildValues(updatedProperties) { error, _ in
                if let error = error {
                    print("Failed to update silver subscription: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Silver subscription updated successfully.")
                    completion(.success(()))
                }
            }
        }
        
        func updateGoldSubscription(monthly: Int, yearly: Int, activeUsers: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            let updatedProperties: [String: Any] = [
                "monthly": monthly,
                "yearly": yearly,
                "activeUsers": activeUsers
            ]
            
            database.child("subscriptions").child("gold").updateChildValues(updatedProperties) { error, _ in
                if let error = error {
                    print("Failed to update gold subscription: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Gold subscription updated successfully.")
                    completion(.success(()))
                }
            }
        }
    
    
    func fetchBronzeSubscription(completion: @escaping (Result<BronzeSubscription, Error>) -> Void) {
        database.child("subscriptions").child("bronze").observeSingleEvent(of: .value) { snapshot in
            guard let subscriptionData = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value for Bronze subscription."])))
                return
            }
            
            guard let monthly = subscriptionData["monthly"] as? Int,
                  let yearly = subscriptionData["yearly"] as? Int,
                  let activeUsers = subscriptionData["activeUsers"] as? Int
            else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Bronze subscription data."])))
                return
            }
            
            let bronzeSubscription = BronzeSubscription(monthly: monthly, yearly: yearly, activeUsers: activeUsers)
            completion(.success(bronzeSubscription))
        }
    }

    func fetchSilverSubscription(completion: @escaping (Result<SilverSubscription, Error>) -> Void) {
        database.child("subscriptions").child("silver").observeSingleEvent(of: .value) { snapshot in
            guard let subscriptionData = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value for Silver subscription."])))
                return
            }
            
            guard let monthly = subscriptionData["monthly"] as? Int,
                  let yearly = subscriptionData["yearly"] as? Int,
                  let activeUser = subscriptionData["activeUser"] as? Int
            else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Silver subscription data."])))
                return
            }
            
            let silverSubscription = SilverSubscription(monthly: monthly, yearly: yearly, activeUser: activeUser)
            completion(.success(silverSubscription))
        }
    }

    func fetchGoldSubscription(completion: @escaping (Result<GoldSubscription, Error>) -> Void) {
        database.child("subscriptions").child("gold").observeSingleEvent(of: .value) { snapshot in
            guard let subscriptionData = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value for Gold subscription."])))
                return
            }
            
            guard let monthly = subscriptionData["monthly"] as? Int,
                  let yearly = subscriptionData["yearly"] as? Int,
                  let activeUsers = subscriptionData["activeUsers"] as? Int
            else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Gold subscription data."])))
                return
            }
            
            let goldSubscription = GoldSubscription(monthly: monthly, yearly: yearly, activeUsers: activeUsers)
            completion(.success(goldSubscription))
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
