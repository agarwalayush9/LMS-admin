//
//  Shelves_AdminApp.swift
//  Shelves-Admin
//
//  Created by Ayush Agarwal on 03/07/24.
//

import SwiftUI

@main
struct Shelves_AdminApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Shelves_iPadDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
