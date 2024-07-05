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

