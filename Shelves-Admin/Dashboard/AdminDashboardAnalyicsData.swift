//
//  AdminDashboardAnalyicsData.swift
//  Shelves-Admin
//
//  Created by Abhay singh on 05/07/24.
//

import Foundation

struct Analytics : Identifiable, Equatable{
    
    var id : String{title}
    var title : String
    var value : Double
    var salesDifferencePercentage : Double
    
    static var analytics : [Analytics]{
        [
            Analytics(title: "Today's Revenue", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "New Members", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "Books Issued", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "Lost or Damaged Books", value: 221, salesDifferencePercentage: 2.5),
        ]
    }
}

//struct for menu Items
struct MenuItem: Identifiable {
    var id: String { option }
    var optionIcon : String
    var option: String
}




//putting menuLis in section header
struct Sections : Identifiable{
    var id : String{sectionHeader}
    var sectionHeader : String
    var menuItem : [MenuItem] = []
    
    static var section : [Sections]{
        [
            Sections(sectionHeader: "OverView", menuItem: [
                MenuItem(optionIcon:"Library", option: "Library"),
                MenuItem(optionIcon:"ManageLibrarian", option: "Manage Librarian"),
                MenuItem(optionIcon: "Complaints", option: "Complaints"),
                MenuItem(optionIcon:"ManageEvents", option: "Manage Events"),
                MenuItem(optionIcon: "MakePayouts", option: "Make Payouts"),
                MenuItem(optionIcon: "UserQueries", option: "User Queries"),
            ]),
            Sections(sectionHeader: "Books", menuItem:[
                MenuItem(optionIcon:"BooksCatalogue", option: "Books Catalogue"),
                MenuItem(optionIcon:"BooksCirculation", option: "Books Circulation"),
                MenuItem(optionIcon:"BookOverdues", option: "Books Overdues/Fines"),
                MenuItem(optionIcon:"ManageSubscription", option: "Manage Subscription"),
                MenuItem(optionIcon:"FineManagement", option: "Fine Management")
                
            ] )
        ]
    }
}

