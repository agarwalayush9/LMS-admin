//
//  SubscriptionPage.swift
//  Shelves-Admin
//
//  Created by Mohit Kumar Gupta on 13/07/24.
//

import SwiftUI

struct SubscriptionView: View {
    @State private var showEditSheet = false
    @State private var selectedTier: SubscriptionTier?
    @State private var menuOpened = false
    
    @State private var tiers = [
        SubscriptionTier(tierNumber: 1, tierName: "Bronze", monthly: 0, yearly: 0, activeMembers: 0),
        SubscriptionTier(tierNumber: 2, tierName: "Silver", monthly: 399, yearly: 699, activeMembers: 0),
        SubscriptionTier(tierNumber: 3, tierName: "Gold", monthly: 699, yearly: 999, activeMembers: 0)
    ]
    
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Manage Subscription Prices")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ForEach(tiers.indices, id: \.self) { index in
                    SubscriptionTierView(tier: $tiers[index], showEditSheet: $showEditSheet, selectedTier: $selectedTier)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            
            .sheet(isPresented: $showEditSheet) {
                if let tier = selectedTier {
                    EditSubscriptionView(tier: tier, showEditSheet: $showEditSheet) { updatedTier in
                        if let index = tiers.firstIndex(where: { $0.id == updatedTier.id }) {
                            tiers[index] = updatedTier
                        }
                    }
                }
            }
            
            if menuOpened {
                sideMenu(width: UIScreen.main.bounds.width * 0.30, menuOpened: menuOpened, toggleMenu: toggleMenu)
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
                        .foregroundStyle(Color.black)
                })
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func toggleMenu() {
        menuOpened.toggle()
    }
    
    func fetchData() {
        DataController.shared.fetchBronzeSubscription { result in
            switch result {
            case .success(let bronzeSubscription):
                tiers[0] = SubscriptionTier(tierNumber: 1, tierName: "Bronze", monthly: bronzeSubscription.monthly, yearly: bronzeSubscription.yearly, activeMembers: bronzeSubscription.activeUsers)
            case .failure(let error):
                print("Failed to fetch Bronze subscription: \(error.localizedDescription)")
            }
        }
        
        DataController.shared.fetchSilverSubscription { result in
            switch result {
            case .success(let silverSubscription):
                tiers[1] = SubscriptionTier(tierNumber: 2, tierName: "Silver", monthly: silverSubscription.monthly, yearly: silverSubscription.yearly, activeMembers: silverSubscription.activeUser)
            case .failure(let error):
                print("Failed to fetch Silver subscription: \(error.localizedDescription)")
            }
        }
        
        DataController.shared.fetchGoldSubscription { result in
            switch result {
            case .success(let goldSubscription):
                tiers[2] = SubscriptionTier(tierNumber: 3, tierName: "Gold", monthly: goldSubscription.monthly, yearly: goldSubscription.yearly, activeMembers: goldSubscription.activeUsers)
            case .failure(let error):
                print("Failed to fetch Gold subscription: \(error.localizedDescription)")
            }
        }
    }
}



struct SubscriptionTierView: View {
    @Binding var tier: SubscriptionTier
    @Binding var showEditSheet: Bool
    @Binding var selectedTier: SubscriptionTier?
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Text("\(tier.tierNumber)")
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                )
            
            Spacer()
                .frame(width: 16)
            
            HStack {
                Text(tier.tierName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.trailing)
                    .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                
                Text("₹\(tier.monthly)/-")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    selectedTier = tier
                    showEditSheet.toggle()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
    }
}

struct EditSubscriptionView: View {
    @State var tier: SubscriptionTier
    @Binding var showEditSheet: Bool
    var onUpdate: (SubscriptionTier) -> Void
    
    @State private var monthlyPrice: String = ""
    @State private var yearlyPrice: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Edit \(tier.tierName) Subscription")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    Text("Subscription Plan Name")
                        .font(.headline)
                    TextField("Plan Name", text: $tier.tierName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading) {
                    Text("Subscription Plan Price")
                        .font(.headline)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Monthly")
                            TextField("Monthly Price", text: $monthlyPrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Yearly")
                            TextField("Yearly Price", text: $yearlyPrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Validate prices
                    guard let monthly = Int(monthlyPrice), let yearly = Int(yearlyPrice) else {
                        showAlert = true
                        alertMessage = "Please enter valid prices."
                        return
                    }
                    
                    // Update subscription prices based on tier
                    switch tier.tierNumber {
                    case 1:
                        DataController.shared.updateBronzeSubscription(monthly: monthly, yearly: yearly, activeUsers: tier.activeMembers) { result in
                            handleUpdateResult(result)
                        }
                    case 2:
                        DataController.shared.updateSilverSubscription(monthly: monthly, yearly: yearly, activeUser: tier.activeMembers) { result in
                            handleUpdateResult(result)
                        }
                    case 3:
                        DataController.shared.updateGoldSubscription(monthly: monthly, yearly: yearly, activeUsers: tier.activeMembers) { result in
                            handleUpdateResult(result)
                        }
                    default:
                        showAlert = true
                        alertMessage = "Invalid subscription tier."
                    }
                    
                }) {
                    Text("Done")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                showEditSheet = false
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Subscription Update"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            // Set the initial values for the text fields
            monthlyPrice = "\(tier.monthly)"
            yearlyPrice = "\(tier.yearly)"
        }
        .onChange(of: showAlert) { _ in
            if !showAlert {
                showEditSheet = false // Dismiss the edit sheet when alert is dismissed
                onUpdate(tier) // Update the parent view's data
            }
        }
    }
    
    private func handleUpdateResult(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            showAlert = true
            alertMessage = "Subscription updated successfully."
        case .failure(let error):
            showAlert = true
            alertMessage = "Failed to update subscription: \(error.localizedDescription)"
        }
    }
}


struct ContentView: View {
    var body: some View {
        SubscriptionView()
    }
}

struct CContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
