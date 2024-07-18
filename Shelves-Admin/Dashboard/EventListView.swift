//
//  EventListView.swift
//  Shlves-Library
//
//  Created by Anay Dubey on 17/07/24.
//

import SwiftUI
import Combine

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let dataController = DataController()

    func fetchEvents() {
        isLoading = true
        dataController.fetchAllEvents { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let events):
                    self?.events = events
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}



struct EventContentView: View {
    @StateObject private var viewModel = EventViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.events) { event in
                        EventRow(event: event)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("All Events Listing")
        }
        .onAppear {
            viewModel.fetchEvents()
        }
    }
}

// EventRow view for EventContentView
struct EventRow: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 16) {
            // Book cover image
            Image(event.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .padding(.leading, 20)
            
            // Event details
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.blue) // Adjust color as needed
                
                
                
                // Author details
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.host)
                            .font(.subheadline)
                            .foregroundColor(.blue) // Adjust color as needed
                    }
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.address)
                        .font(.subheadline)
                        .foregroundColor(.blue) // Adjust color as needed
                }
                
                Spacer()
                
                // Date and price
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Date")
                            .font(.headline)
                            .foregroundColor(.blue) // Adjust color as needed
                        
                        Text("\(event.date)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Price")
                            .font(.headline)
                            .foregroundColor(.blue) // Adjust color as needed
                        
                        Text("$\(event.fees)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 20)
                }
            }
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


