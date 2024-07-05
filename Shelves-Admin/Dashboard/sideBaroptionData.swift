//
//  sideBaroptionData.swift
//  Shlves-Library
//
//  Created by Abhay singh on 03/07/24.
//

import Foundation

struct sideBarOptions: Identifiable, Equatable {
    var id: String{optionName}
    var optionName : String
    
    static var sideBaroptionList : [sideBarOptions]{
    [
        sideBarOptions(optionName: "Overview"),
        sideBarOptions(optionName: "Books Inventory"),
        sideBarOptions(optionName: "Books"),
        
    ]
    }
}


