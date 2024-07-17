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
    
    
    func fetchNumberOfBooks(completion: @escaping (Result<Int, Error>) -> Void) {
        database.child("books").observeSingleEvent(of: .value) { snapshot, error in
            if let error = error {
                completion(.failure(error as! Error))
                return
            }
            
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                // If there are no books or the snapshot cannot be casted to [String: Any]
                completion(.success(0))
                return
            }
            
            // Get the count of children under "books" node
            let numberOfBooks = snapshotDict.count
            completion(.success(numberOfBooks))
        }
    }

    
    func fetchTotalRevenue(completion: @escaping (Result<Int, Error>) -> Void) {
            database.child("events").observeSingleEvent(of: .value) { snapshot in
                guard let eventsDict = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                    return
                }

                var totalRevenue: Int = 0

                for (_, dict) in eventsDict {
                    guard let revenue = dict["revenue"] as? Int else {
                        print("Failed to parse event revenue.")
                        continue
                    }

                    totalRevenue += revenue
                }

                print("Total revenue: \(totalRevenue)")
                completion(.success(totalRevenue))
            }
        }

    
    func fetchNumberOfMembers(completion: @escaping (Result<Int, Error>) -> Void) {
        database.child("members").observeSingleEvent(of: .value) { snapshot, error in
            if let error = error {
                completion(.failure(error as! Error))
                return
            }
            
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                // If there are no books or the snapshot cannot be casted to [String: Any]
                completion(.success(0))
                return
            }
            
            // Get the count of children under "books" node
            let numberOfBooks = snapshotDict.count
            completion(.success(numberOfBooks))
        }
    }
    
    func fetchNumberOfEvents(completion: @escaping (Result<Int, Error>) -> Void) {
        database.child("events").observeSingleEvent(of: .value) { snapshot in
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                completion(.success(0))
                return
            }
            
            let numberOfEvents = snapshotDict.count
            completion(.success(numberOfEvents))
            print(numberOfEvents)
        }
    }
    
    
    
    func fetchPendingEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        database.child("PendingEvents").observe(.value) { snapshot in
            guard let eventsSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                return
            }
            
            var events: [Event] = []
            
            for eventSnapshot in eventsSnapshot {
                guard let eventDict = eventSnapshot.value as? [String: Any] else {
                    print("Failed to parse event data for event with ID: \(eventSnapshot.key)")
                    continue
                }
                
                do {
                    if let event = try self.parseEvent(from: eventDict, eventId: eventSnapshot.key) {
                        events.append(event)
                    }
                } catch {
                    print("Failed to parse event data: \(error.localizedDescription)")
                }
            }
            
            print("Fetched \(events.count) events.")
            completion(.success(events))
        }
    }

    
    func fetchAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        database.child("events").observeSingleEvent(of: .value) { snapshot in
            guard let eventsSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                return
            }
            
            var events: [Event] = []
            
            for eventSnapshot in eventsSnapshot {
                guard let eventDict = eventSnapshot.value as? [String: Any] else {
                    print("Failed to parse event data for event with ID: \(eventSnapshot.key)")
                    continue
                }
                
                do {
                    if let event = try self.parseEvent(from: eventDict, eventId: eventSnapshot.key) {
                        events.append(event)
                    }
                } catch {
                    print("Failed to parse event data: \(error.localizedDescription)")
                }
            }
            
            print("Fetched \(events.count) events.")
            completion(.success(events))
        }
    }
    
    
    
    private func parseEvent(from dict: [String: Any], eventId: String) throws -> Event? {
        // Extract values with conditional binding
        guard
            let name = dict["name"] as? String,
            let host = dict["host"] as? String,
            let dateInterval = dict["date"] as? TimeInterval,
            let timeInterval = dict["time"] as? TimeInterval,
            let address = dict["address"] as? String,
            let duration = dict["duration"] as? String,
            let description = dict["description"] as? String,
            let tickets = dict["tickets"] as? Int,
            let imageName = dict["imageName"] as? String,
            let fees = dict["fees"] as? Int,
            let revenue = dict["revenue"] as? Int,
            let status = dict["status"] as? String
        else {
            // Print missing or invalid keys
            let keyMissing = [
                "name": dict["name"],
                "host": dict["host"],
                "dateInterval": dict["dateInterval"],
                "timeInterval": dict["timeInterval"],
                "address": dict["address"],
                "duration": dict["duration"],
                "description": dict["description"],
                "tickets": dict["tickets"],
                "imageName": dict["imageName"],
                "fees": dict["fees"],
                "revenue": dict["revenue"],
                "status": dict["status"]
            ]
            
            print("Failed to parse event data. Missing or invalid key/value: \(keyMissing)")
            return nil
        }

        // Parse date and time
        let date = Date(timeIntervalSince1970: dateInterval)
        let time = Date(timeIntervalSince1970: timeInterval)

        // Parse registered members if available
        var registeredMembers: [Member] = []
        if let registeredMembersArray = dict["registeredMembers"] as? [[String: Any]] {
            for memberDict in registeredMembersArray {
                guard
                    let name = memberDict["name"] as? String,
                    let email = memberDict["email"] as? String,
                    let lastName = memberDict["lastName"] as? String,
                    let phoneNumber = memberDict["phoneNumber"] as? Int
                else {
                    print("Failed to parse registered member data.")
                    continue
                }
                let user = Member(firstName: name, lastName: lastName, email: email, phoneNumber: phoneNumber)
                registeredMembers.append(user)
            }
        }

        // Return Event object
        return Event(
            id: eventId,
            name: name,
            host: host,
            date: date,
            time: time,
            address: address,
            duration: duration,
            description: description,
            registeredMembers: registeredMembers,
            tickets: tickets,
            imageName: imageName,
            fees: fees,
            revenue: revenue,
            status: status
        )
    }

    func addEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventID = event.id
        
        // Check if the event ID already exists
        database.child("events").child(eventID).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // Event ID already exists
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Event ID is already in use."])))
            } else {
                // Add the event to the database
                self.saveEventToDatabase(event) { result in
                    completion(result)
                }
            }
        }
    }
    
    private func saveEventToDatabase(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventID = event.id
        let eventDictionary = event.toDictionary()
        
        // Save event to database
        database.child("events").child(eventID).setValue(eventDictionary) { error, _ in
            if let error = error {
                print("Failed to save event: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Event saved successfully.")
                completion(.success(()))
            }
        }
    }
    
    
    func deletePendingEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
            let eventID = event.id
            
            database.child("PendingEvents").child(eventID).removeValue { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    func addNotification(_ notification: Notification, completion: @escaping (Error?) -> Void) {
            let notificationsRef = database.child("notifications").childByAutoId()

            // Convert notification to dictionary
            let notificationData = notification.toDictionary()

            // Add notification to Firebase
            notificationsRef.setValue(notificationData) { error, _ in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    
    }
