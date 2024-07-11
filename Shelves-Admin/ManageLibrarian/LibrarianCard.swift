//
//  LibrarianCard.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 11/07/24.
//

import SwiftUI

struct LibrarianCard: View {
    var librarian: Librarian
    @Binding var selectedLibrarian: Librarian?
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.xxs) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 110, height: 110)
                .background(
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110)
                        .clipped()
                )
                .cornerRadius(110)
            Text(librarian.name)
                .font(Font.custom("DM Sans", size: 20).weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
            Text(librarian.phoneNumber)
                .font(Font.custom("DM Sans", size: 20).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
            Button(action: {
                selectedLibrarian = librarian
                showSheet = true
            }) {
                Text(librarian.status)
                    .font(Font.custom("DM Sans", size: 16).weight(.bold))
                    .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                    .frame(width: 140, height: 25)
                    .padding(.horizontal, Constants.default)
                    .padding(.vertical, 7)
                    .background(Color(red: 1, green: 0.74, blue: 0.28))
                    .cornerRadius(61)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 25)
        .frame(width: 195, alignment: .center)
        .cornerRadius(Constants.xxs)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.xxs)
                .inset(by: 1.5)
                .stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3)
        )
    }
}
