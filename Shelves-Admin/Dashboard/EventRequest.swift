import SwiftUI
import Combine

class EventRequestViewModel: ObservableObject {
    @Published var pendingEvents: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let dataController = DataController()

    func fetchPendingEvents() {
        isLoading = true
        dataController.fetchPendingEvents { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let events):
                    self?.pendingEvents = events
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

import SwiftUI

struct EventRequest: View {
    @State private var menuOpened = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @StateObject private var viewModel = EventRequestViewModel()
    @State private var shouldRefresh = false // Add this state variable

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView()
                    .ignoresSafeArea(.all)
                backgroundView()
                    .ignoresSafeArea(.all)
                    .blur(radius: menuOpened ? 10 : 0)
                    .animation(.easeInOut(duration: 0.25), value: menuOpened)
                ScrollView {
                    VStack(alignment: .center) {
                        ForEach(viewModel.pendingEvents) { event in
                            EventRequestCard(
                                event: event,
                                width: UIScreen.main.bounds.width * 0.95,
                                height: 200,
                                onApprove: {
                                    DataController.shared.addEvent(event) { result in
                                        switch result {
                                        case .success:
                                            alertMessage = "Event approved"
                                            shouldRefresh.toggle() // Toggle to refresh
                                        case .failure(let error):
                                            alertMessage = "Failed to add event: \(error.localizedDescription)"
                                        }
                                        showAlert = true
                                        
                                        
                                    }
                                    let notification = Notification(title: "Event Approved",
                                    message: "The event \(event.name) has been approved.")
                                    DataController.shared.addNotification(notification)
                                    {  error in
                                        if let error = error {
                                            print("Failed to add approval notification: \(error.localizedDescription)")
                                        } else {
                                            print("Approval notification added successfully.")
                                        }
                                    }
                                    
                                    DataController.shared.deletePendingEvent(event) { result in
                                        switch result {
                                        case .success:
                                            alertMessage = "Event approved and removed from pending events."
                                            shouldRefresh.toggle() // Toggle to refresh
                                        case .failure(let error):
                                            alertMessage = "Failed to remove event from pending events: \(error.localizedDescription)"
                                        }
                                        showAlert = true
                                    }
                                },
                                onDecline: {
                                    alertMessage = "Event disapproved."
                                    showAlert = true
                                    
                                    DataController.shared.deletePendingEvent(event) { result in
                                        switch result {
                                        case .success:
                                            alertMessage = "Event disapproved and removed from pending events."
                                            shouldRefresh.toggle() // Toggle to refresh
                                        case .failure(let error):
                                            alertMessage = "Failed to remove event from pending events: \(error.localizedDescription)"
                                        }
                                        
                                        let notification = Notification(title: "Event Disapproved",
                                        message: "The event \(event.name) has been disapproved.")
                                        DataController.shared.addNotification(notification)
                                        {  error in
                                            if let error = error {
                                                print("Failed to add disapproval notification: \(error.localizedDescription)")
                                            } else {
                                                print("Disapproval notification added successfully")
                                        }
                                    }
                                        showAlert = true
                                    }
                                }
                            )
                        }
                    }
                    .padding([.top])
                }
                if menuOpened {
                    sideMenu(
                        width: UIScreen.main.bounds.width * 0.30,
                        menuOpened: menuOpened,
                        toggleMenu: toggleMenu
                    )
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                }
            }
            .navigationTitle("LMS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        menuOpened.toggle()
                    }, label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.mainFont)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}, label: {
                        Image(systemName: "books.vertical")
                            .foregroundColor(Color.mainFont)
                    })
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                shouldRefresh.toggle()
                viewModel.fetchPendingEvents()
            }
            .onChange(of: shouldRefresh) { _ in
                viewModel.fetchPendingEvents()
            }
        }
    }

    func toggleMenu() {
        menuOpened.toggle()
    }
}


//MARK: Custom car for each event card
struct EventRequestCard: View {
    var event: Event
    var width: Double
    var height: Double
    var onApprove: () -> Void
    var onDecline: () -> Void
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                HStack {
                    HStack {
                        Image(event.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 112, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                    }
                    Spacer()
                    HStack {
                        VStack {
                            Text("Event Title: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                                .foregroundStyle(.gray)
                            Text(event.name)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                            Text("Date: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                                .foregroundStyle(.gray)
                            Text(event.date, style: .date)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                            Text("Location: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                                .foregroundStyle(.gray)
                            Text(event.address)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                            Text("Host: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                                .foregroundStyle(.gray)
                            Text(event.host)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                )
                        }
                    }
                    Spacer()
                    HStack {
                        VStack {
                            Spacer()
                            AorDCustomButton(
                                width: 200,
                                height: 100,
                                title: "Approve",
                                colorName: "ApproveButton",
                                fontColor: "ApproveFontColor",
                                action: onApprove
                            )
                            Spacer()
                            AorDCustomButton(
                                width: 200,
                                height: 100,
                                title: "Decline",
                                colorName: "DeclineButton",
                                fontColor: "DeclineFontColor",
                                action: onDecline
                            )
                            Spacer()
                        }
                    }
                    .padding()
                }
            )
    }
}

struct AorDCustomButton: View {
    var width: CGFloat
    var height: CGFloat
    var title: String
    var colorName: String
    var fontColor: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(title)
                    .font(Font.custom("DM Sans", size: 20).weight(.bold))
                    .foregroundColor(Color(fontColor))
            }
            .padding(.all)
            .frame(maxWidth: width, maxHeight: height)
            .background(Color(colorName))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}


#Preview {
    EventRequest()
}
