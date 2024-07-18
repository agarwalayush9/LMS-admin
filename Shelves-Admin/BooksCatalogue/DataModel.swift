//
//  DataModel.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 06/07/24.


import Foundation

struct Book: Identifiable, Codable {
    var id = UUID()
    let bookCode: String
    let bookCover: String
    let bookTitle: String
    let author: String
    let genre: [Genre]
    let issuedDate: String
    let returnDate: String
    let status: String
    var quantity: Int?
    
    func toDictionary() -> [String: Any] {
            return [
                "id": id.uuidString,
                "bookCode": bookCode,
                "bookCover": bookCover,
                "bookTitle": bookTitle,
                "author": author,
                "genre": genre.map { $0.rawValue },
                "issuedDate": issuedDate,
                "returnDate": returnDate,
                "status": status
                
            ]
        }
}

enum Genre: String, Codable {
    case Horror
    case Mystery
    case Fiction
    case Finance
    case Fantasy
    case Business
    case Romance
    case Psychology
    case YoungAdult
    case SelfHelp
    case HistoricalFiction
    case NonFiction
    case ScienceFiction
    case Literature
}

struct Event: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var host: String
    var date: Date
    var time: Date
    var address: String
    var duration: String
    var description: String
    var registeredMembers: [Member]
    var tickets: Int
    var imageName: String
    var fees: Int
    var revenue: Int
    var status: String
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "host": host,
            "date": date.timeIntervalSince1970, // Convert Date to TimeInterval
            "time": time.timeIntervalSince1970,
            "address": address,
            "duration": duration,
            "description": description,
            "registeredMembers": registeredMembers.map { $0.toDictionary() }, // Convert each member to dictionary
            "tickets": tickets,
            "imageName": imageName,
            "fees": fees,
            "revenue": revenue,
            "status": status
        ]
    }
}



struct Author: Identifiable {
    let id = UUID()
    let name: String
    let title: String
    let description: String
    let image: String
}

struct Member {
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: Int
    var subscriptionPlan: String?
    var genre: [Genre]?
    var registeredEvents: [Event]? // This should be [Event] since it's an array of events

    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phoneNumber": phoneNumber
        ]

        if let subscriptionPlan = subscriptionPlan {
            dictionary["subscriptionPlan"] = subscriptionPlan
        }

        if let genre = genre {
            dictionary["genre"] = genre.map { $0.rawValue }
        }
        
        if let registeredEvents = registeredEvents {
            // Convert each event to dictionary
            dictionary["registeredEvents"] = registeredEvents.map { $0.toDictionary() }
        }
        return dictionary
    }
}

struct Notification: Identifiable {
    var id = UUID()
    
    var title: String
    var message: String

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "message": message
        ]
    }
}
