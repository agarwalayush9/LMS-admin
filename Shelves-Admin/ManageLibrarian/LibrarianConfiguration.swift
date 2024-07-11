//
//  LibrarianConfiguration.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 11/07/24.
//

import Foundation

struct Config {
    static var sendGridAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "config", ofType: "plist") else {
            fatalError("Couldn't find file 'config.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "SENDGRID_API_KEY") as? String else {
            fatalError("Couldn't find key 'SENDGRID_API_KEY' in 'config.plist'.")
        }
        return value
    }
}

