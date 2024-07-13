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
    @State var menuOpened = false
    
    @State private var tiers = [
        SubscriptionTier(tierNumber: 1, tierName: "Bronze", price: "₹0/-"),
        SubscriptionTier(tierNumber: 2, tierName: "Silver", price: "₹399/-"),
        SubscriptionTier(tierNumber: 3, tierName: "Gold", price: "₹699/-")
    ]
    
    
    
    var body: some View {
        ZStack{
            
            
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
        
    }
    
    
    
    func toggleMenu() {
        menuOpened.toggle()
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
                
                Text(tier.price)
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
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Yearly")
                            TextField("Yearly Price", text: $yearlyPrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Update the price and dismiss the sheet
                    tier.price = "₹\(monthlyPrice)/-"
                    onUpdate(tier)
                    showEditSheet = false
                    
                    // Get the admin's email from UserDefaults
                    if let email = UserDefaults.standard.string(forKey: "adminEmail") {
                        // Update the subscription price in Firebase
                        let dataController = DataController()
                        dataController.updateSubscriptionPrice(
                            email: email,
                            tierNumber: tier.tierNumber,
                            monthlyPrice: monthlyPrice,
                            yearlyPrice: yearlyPrice
                        ) { result in
                            switch result {
                            case .success:
                                                            DispatchQueue.main.async {
                                                                showAlert = true
                                                                alertMessage = "Subscription price updated successfully."
                                                            }
                                                        case .failure(let error):
                                                            DispatchQueue.main.async {
                                                                showAlert = true
                                                                alertMessage = "Failed to update subscription price: \(error.localizedDescription)"
                                                            }
                            }
                        }
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
            let prices = tier.price.split(separator: "₹")
            if prices.count > 1 {
                monthlyPrice = String(prices[1].dropLast(2)) // removing "/-"
            }
        }
    }
}


struct SubscriptionTier: Identifiable {
    var id = UUID()
    var tierNumber: Int
    var tierName: String
    var price: String
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
