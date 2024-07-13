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

struct BronzeSubscription {
    var monthly: Int
    var yearly: Int
    
    func toDictionary() -> [String: Any] {
        return [
            "monthly": monthly,
            "yearly": yearly
        ]
    }
}

struct SilverSubscription {
    var monthly: Int
    var yearly: Int
    
    func toDictionary() -> [String: Any] {
        return [
            "monthly": monthly,
            "yearly": yearly
        ]
    }
}

struct GoldSubscription {
    var monthly: Int
    var yearly: Int
    
    func toDictionary() -> [String: Any] {
        return [
            "monthly": monthly,
            "yearly": yearly
        ]
    }
}

struct Admin {
    var email: String
    var bronzeSubscription: BronzeSubscription
    var silverSubscription: SilverSubscription
    var goldSubscription: GoldSubscription
    
    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "bronzeSubscription": bronzeSubscription.toDictionary(),
            "silverSubscription": silverSubscription.toDictionary(),
            "goldSubscription": goldSubscription.toDictionary()
        ]
    }
}
