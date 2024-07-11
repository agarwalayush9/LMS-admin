//
//  AddBookOptionsView.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 11/07/24.
//

import SwiftUI

struct AddBookOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddBookDetails = false
    var addBook: (Book) -> Void
    var books: [Book] // Pass existing books

    var body: some View {
        VStack {
            Text("Add Books")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            VStack(spacing: 60) {
                Button(action: {
                    // Action for ISBN Code Scanning
                }) {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                            .font(.system(size: 40))
                        Text("Using ISBN Code Scanning")
                            .font(.headline)
                    }
                    .padding(.all, 40)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.orange, lineWidth: 2))
                }

                Button(action: {
                    // Action for Batch Upload
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 40))
                        Text("Batch Upload (CSV, Spreadsheet)")
                            .font(.headline)
                    }
                    .padding(.all, 40)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
                }

                Button(action: {
                    showingAddBookDetails = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 40))
                        Text("Enter Details Manually")
                            .font(.headline)
                    }
                    .padding(.all, 40)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
                }
                .sheet(isPresented: $showingAddBookDetails) {
                    AddBookDetailsView(addBook: addBook, books: books)
                }
            }
            .padding()

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: 500) // Limit the width of the pop-up
    }
}
