//
//  AdminDashboardStructs.swift
//  Shelves-Admin
//
//  Created by Abhay singh on 05/07/24.
//


import Foundation
import SwiftUI

struct userName : View {
    var userName : String
    var body: some View {
            Text("Hello, \(userName)!")
                .font(
                  Font.custom("DM Sans", size: 48)
                    .weight(.medium)
                )
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}




struct card : View {
    var title : String
    var value : Double
    var salesDifferencePercentage : Double
    var body: some View {
        Rectangle()
            .foregroundStyle(.white)
            .frame(width: 258, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
               cardData(title: title,
                        value: value,
                        salesDifferencePercentage: salesDifferencePercentage)
            )
    }
}


struct DashboardAnalytics : View {
    let data = Analytics.analytics
    var body: some View {
        ForEach(data){ datunm in
            card(title: datunm.title,
                 value: datunm.value,
                 salesDifferencePercentage: datunm.salesDifferencePercentage)
        }
    }
}

struct cardData : View {
    var title : String
    var value : Double
    var salesDifferencePercentage : Double
    
    var body: some View {
        HStack {
            VStack {
                Text("$\(String(format: "%.2f", value))")
                  .font(
                    Font.custom("DM Sans", size: 32)
                      .weight(.bold)
                  )
                  .padding(.leading, 19)
                  .padding()
                Text(title)
                  .font(
                    Font.custom("DM Sans", size: 16)
                      .weight(.medium)
                  )
                  .padding(.leading, 19)
                  
            }
            .foregroundColor(Color(red: 0.16, green: 0.14, blue: 0.14))
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            
            VStack {
                cardIcon(imageName: "person.3")
                    .padding(.bottom, 16)
                Text("\(String(format: "%.2f", salesDifferencePercentage))%")
                  .font(
                    Font.custom("DM Sans", size: 12)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0, green: 0.74, blue: 0.35))
              .padding(.trailing)
            }
        }
    }
}


struct cardIcon : View {
    var imageName : String
    var body: some View {
            Circle()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color("cardIconColor"))
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                        
                )
                .padding(.trailing)
    }
}

struct todayDateAndTime : View {
    var body: some View {
        Text(currentDateAndTime())
          .font(
            Font.custom("DM Sans", size: 24)
              .weight(.medium)
          )
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}


struct AnalyticHeader : View {
    var title : String
    var body: some View {
        Text(title)
          .font(
            Font.custom("DM Sans", size: 20)
              .weight(.medium)
          )
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .padding([.leading], 64)
    }
}


func currentDateAndTime() -> String {
        let now = Date()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy | EEEE"
        let dateString = dateFormatter.string(from: now)
        
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: now)
        
        return "\(dateString), \(timeString)"
    }

#Preview {
    AdminDashboard()
}
