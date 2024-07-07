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
                MenuItem(optionIcon:"majesticons_library-line", option: "Library"),
                MenuItem(optionIcon:"charm_people", option: "Manage Librarian"),
                MenuItem(optionIcon: "hugeicons_complaint", option: "Complaints"),
                MenuItem(optionIcon:"ic_round-event-note", option: "Manage Events"),
                MenuItem(optionIcon: "fluent_payment-16-regular", option: "Make Payouts"),
                MenuItem(optionIcon: "Traced Image", option: "User Queries"),
            ]),
            Sections(sectionHeader: "Books", menuItem:[
                MenuItem(optionIcon:"hugeicons_books-02", option: "Books Catalogue"),
                MenuItem(optionIcon:"hugeicons_bookshelf-01", option: "Books Circulation"),
                MenuItem(optionIcon:"fluent_clock-bill-16-regular", option: "Books Overdues/Fines"),
                MenuItem(optionIcon:"lucide_ticket", option: "Manage Subscription"),
                MenuItem(optionIcon:"uil_bill", option: "Fine Management")
                
            ] )
        ]
    }
}

