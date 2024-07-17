//
//  EventListView.swift
//  Shlves-Library
//
//  Created by Anay Dubey on 17/07/24.
//

import SwiftUI


struct EventContentView: View {
    let events: [EventListView] = [
        EventListView(bookCover: "bookCoverImage1", eventName: "Author's Meet", eventId: "#4235532", authorName: "Marie Johnson", authorImage: "authorImage1", authorId: "#4235532", date: "19th July", price: "$40"),
        EventListView(bookCover: "bookCoverImage1", eventName: "Author's Meet", eventId: "#4235532", authorName: "Marie Johnson", authorImage: "authorImage1", authorId: "#4235532", date: "19th July", price: "$40"),
        EventListView(bookCover: "bookCoverImage1", eventName: "Author's Meet", eventId: "#4235532", authorName: "Marie Johnson", authorImage: "authorImage1", authorId: "#4235532", date: "19th July", price: "$40"),
        EventListView(bookCover: "bookCoverImage1", eventName: "Author's Meet", eventId: "#4235532", authorName: "Marie Johnson", authorImage: "authorImage1", authorId: "#4235532", date: "19th July", price: "$40"),
        EventListView(bookCover: "bookCoverImage1", eventName: "Author's Meet", eventId: "#4235532", authorName: "Marie Johnson", authorImage: "authorImage1", authorId: "#4235532", date: "19th July", price: "$40")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(events) { event in
                        EventRow(event: event)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("All Events Listing")
        }
    }
}

// Event model for EventContentView
struct EventListView: Identifiable {
    let id = UUID()
    let bookCover: String
    let eventName: String
    let eventId: String
    let authorName: String
    let authorImage: String
    let authorId: String
    let date: String
    let price: String
}

// EventRow view for EventContentView
struct EventRow: View {
    let event: EventListView
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            Image(event.bookCover)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .background(Color(.dashboardbg))
                .padding(.leading,20)
            //MARK: event name and ID
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.eventName)
                    .font(.headline)
                    .foregroundColor(.customButton)
                
                Text(event.eventId)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            HStack {
                Image(event.authorImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.authorName)
                        .font(.subheadline)
                        .foregroundColor(.customButton)
                    
                    Text(event.authorId)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Date")
                    .font(.headline)
                    .foregroundColor(.customButton)
                
                Text(event.date)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Price")
                    .font(.headline)
                    .foregroundColor(.customButton)
                
                Text(event.price)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(.trailing, 20)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .opacity(0.3),
            alignment: .bottom
        )
    }
}

// Preview provider
struct EventContentView_Previews: PreviewProvider {
    static var previews: some View {
        EventContentView()
    }
}
