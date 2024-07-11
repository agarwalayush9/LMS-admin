//
//  AddBookDetailsView.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 11/07/24.
//

import SwiftUI

struct AddBookDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var bookTitle = ""
    @State private var author = ""
    @State private var genre = Genre.Fiction
    @State private var quantity = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var addBook: (Book) -> Void
    var books: [Book]

    let genres: [Genre] = [
        .Horror, .Mystery, .Fiction, .Finance, .Fantasy, .Business, .Romance,
        .Psychology, .YoungAdult, .SelfHelp, .HistoricalFiction, .NonFiction,
        .ScienceFiction, .Literature
    ]

    var body: some View {
        VStack {
            Text("Enter Book Details")
                .font(.title)
                .padding()

            Form {
                TextField("Book Title", text: $bookTitle)
                TextField("Author", text: $author)
                Picker("Genre", selection: $genre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre.rawValue).tag(genre)
                    }
                }
                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad)
            }

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    guard let quantityValue = Int(quantity) else {
                        alertMessage = "Please enter a valid numeric quantity."
                        showAlert = true
                        return
                    }

                    if books.contains(where: { $0.bookTitle == bookTitle && $0.author == author }) {
                        alertMessage = "A book with the same title and author already exists."
                        showAlert = true
                        return
                    }

                    let newBook = Book(
                        bookCode: "978-\(Int.random(in: 1000000...9999999))",
                        bookCover: "book_cover",
                        bookTitle: bookTitle.isEmpty ? "Unknown Title" : bookTitle,
                        author: author.isEmpty ? "Unknown Author" : author,
                        genre: [genre],
                        issuedDate: "2024-05-01",
                        returnDate: "2024-06-01",
                        status: "Available",
                        quantity: quantityValue
                    )
                    addBook(newBook)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: 500)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
