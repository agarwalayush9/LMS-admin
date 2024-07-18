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


struct DashboardAnalytics: View {
    @State private var analytics = Analytics.analytics
    @State private var isLoading = false // Track loading state
    @StateObject private var viewModel = EventViewModel()
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Fetching data...") // Show progress view while loading
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                    HStack {
                        ForEach(analytics) { data in
                            card(title: data.title,
                                 value: data.value,
                                 salesDifferencePercentage: data.salesDifferencePercentage)
                                .padding()
                        }
                    }
            }
        }
        .onAppear {
            isLoading = true // Start loading indicator
            fetchAndUpdateBooks()
            fetchAndUpdateEvents()
            fetchAndUpdateRevenue()
            fetchAndUpdateMembers()
        }
    }
    
    func fetchAndUpdateBooks() {
        DataController.shared.fetchNumberOfBooks { result in
            switch result {
            case .success(let count):
                Analytics.updateTotalBooks(count: count)
                self.analytics = Analytics.analytics // Update the local state with the latest data
            case .failure(let error):
                print("Failed to fetch number of books: \(error.localizedDescription)")
                // Handle error if needed
            }
        }
    }
    
    func fetchAndUpdateEvents() {
        DataController.shared.fetchNumberOfEvents { result in
            isLoading = false // Stop loading indicator
            switch result {
            case .success(let count):
                Analytics.updateTotalEvents(count: count)
                self.analytics = Analytics.analytics // Update the local state with the latest data
            case .failure(let error):
                print("Failed to fetch number of events: \(error.localizedDescription)")
                // Handle error if needed
            }
        }
    }
    
    func fetchAndUpdateRevenue() {
        DataController.shared.fetchTotalRevenue { result in
            isLoading = false // Stop loading indicator
            switch result {
            case .success(let count):
                Analytics.updateTotalRevenue(count: count)
                self.analytics = Analytics.analytics // Update the local state with the latest data
            case .failure(let error):
                print("Failed to fetch revenue: \(error.localizedDescription)")
                // Handle error if needed
            }
        }
    }
    
    func fetchAndUpdateMembers() {
        DataController.shared.fetchNumberOfMembers { result in
            isLoading = false // Stop loading indicator
            switch result {
            case .success(let count):
                Analytics.updateTotalMembers(count: count)
                self.analytics = Analytics.analytics // Update the local state with the latest data
            case .failure(let error):
                print("Failed to fetch number of members: \(error.localizedDescription)")
                // Handle error if needed
            }
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
                Text("\(String(format: "%.0f", value))")
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

//#Preview {
//    AdminDashboard(isLoggedIn: $isLoggedIn)
//}
