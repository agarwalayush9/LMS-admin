//
//  AdminDashboardAnalyicsData.swift
//  Shelves-Admin
//
//  Created by Abhay singh on 05/07/24.
//

import Foundation
import SwiftUI

struct Analytics: Identifiable, Equatable {
    var id: String { title }
    var title: String
    var value: Double
    var salesDifferencePercentage: Double
    
    static var analytics: [Analytics] = [
        Analytics(title: "New Members", value: 221, salesDifferencePercentage: 2.5),
        Analytics(title: "Books Issued", value: 221, salesDifferencePercentage: 2.5),
        Analytics(title: "Lost or Damaged Books", value: 221, salesDifferencePercentage: 2.5)
    ]
    
    static func updateTotalBooks(count: Int) {
        if let index = analytics.firstIndex(where: { $0.title == "Total Books" }) {
            analytics[index].value = Double(count)
        } else {
            let totalBooksAnalytics = Analytics(title: "Total Books", value: Double(count), salesDifferencePercentage: 0)
            analytics.append(totalBooksAnalytics)
        }
    }
}



//struct for menu Items
struct MenuItem: Identifiable {
    var id: String { option }
    var optionIcon : String
    var option: String
    var destination: AnyView
    var isClickable: Bool
}

//putting menuLis in section header
struct Sections : Identifiable{
    var id : String{sectionHeader}
    var sectionHeader : String
    var menuItem : [MenuItem]
    
    static var section : [Sections]{
        [
                    Sections(sectionHeader: "OverView", menuItem: [
                        MenuItem(optionIcon: "Library", option: "Dashboard", destination: AnyView(AdminDashboard()), isClickable: true),
                        MenuItem(optionIcon: "ManageLibrarian", option: "Manage Librarian", destination: AnyView(AddLibrarian()), isClickable: true),
                        MenuItem(optionIcon: "Complaints", option: "Complaints", destination: AnyView(EmptyView()), isClickable: false),
                        MenuItem(optionIcon: "ManageEvents", option: "Manage Events", destination: AnyView(EmptyView()), isClickable: false),
                        MenuItem(optionIcon: "MakePayouts", option: "Make Payouts", destination: AnyView(EmptyView()), isClickable: false),
                        MenuItem(optionIcon: "UserQueries", option: "User Queries", destination: AnyView(EmptyView()), isClickable: false),
                    ]),
                    Sections(sectionHeader: "Books", menuItem: [
                        MenuItem(optionIcon: "BooksCatalogue", option: "Books Catalogue", destination: AnyView(BooksCatalogue( )), isClickable: true),
                        MenuItem(optionIcon: "BooksCirculation", option: "Books Circulation", destination: AnyView(EmptyView()), isClickable: false),
                        MenuItem(optionIcon: "BookOverdues", option: "Books Overdues/Fines", destination: AnyView(EmptyView()), isClickable: false),
                        MenuItem(optionIcon: "ManageSubscription", option: "Manage Subscription", destination: AnyView(SubscriptionView()), isClickable: true),
                        MenuItem(optionIcon: "FineManagement", option: "Fine Management", destination: AnyView(EmptyView()), isClickable: false)
                    ])
                ]
    }
}

