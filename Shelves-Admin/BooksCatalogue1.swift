//
//  BooksCatalogue1.swift
//  Shelves-Admin
//
//  Created by Mohit Kumar Gupta on 04/07/24.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.32, green: 0.23, blue: 0.06), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 255/255, green: 246/255, blue: 227/255)))
                    .frame(width: 25, height: 25)
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                        .frame(width: 20, height: 20)
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct BooksCatalogue1: View {
    @State private var selectedBooks = Set<UUID>()
    
    @State private var books: [Book] = []

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BooksCatalogue1()) {
                    Label("Khvaab Library", systemImage: "books.vertical")
                        .font(.title)
                        .foregroundColor(.brown)
                }
                NavigationLink(destination: BooksCatalogue1()) {
                    Label("Book Catalogues", systemImage: "book")
                        .font(.title2)
                        .foregroundColor(.brown)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Khvaab Library")
           
            
            
            VStack {
             Spacer()
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        HStack {
                            CheckBoxView(
                                isChecked: Binding<Bool>(
                                    get: { selectedBooks.count == books.count },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedBooks = Set(books.map { $0.id })
                                        } else {
                                            selectedBooks.removeAll()
                                        }
                                    }
                                )
                            )

                            .frame(width: 50, alignment: .center)
                            
                            Text("Book Code")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Book Cover")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Book Title")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Author")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Genre/Category")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Issued Date")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Return Date")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Book Status")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Actions")
                                .frame(maxWidth: 80, alignment: .leading)
                        }
                        .font(.headline)
                        .padding(.horizontal)
                        
                        Divider()
                        
                        ForEach(books) { book in
                            HStack {
                                CheckBoxView(
                                    isChecked: Binding<Bool>(
                                        get: { selectedBooks.contains(book.id) },
                                        set: { isSelected in
                                            if isSelected {
                                                selectedBooks.insert(book.id)
                                            } else {
                                                selectedBooks.remove(book.id)
                                            }
                                        }
                                    )
                                )
                                .frame(width: 50, alignment: .center)
                                
                                
                                Text(book.bookCode)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(book.bookCover)
                                    .resizable()
                                    .frame(width: 60, height: 80)
                                    .cornerRadius(5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(book.bookTitle)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(book.author)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(book.genre.map { $0.rawValue }.joined(separator: ", "))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(book.issuedDate)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(book.returnDate)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(book.status)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(book.status == "Issued" ? .red : .green)
                                
                                HStack {
                                    Button(action: {
                                        // Action for edit button
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Button(action: {
                                        // Action for more options
                                    }) {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .frame(maxWidth: 80, alignment: .leading)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .background(selectedBooks.contains(book.id) ? Color(red: 255/255, green: 246/255, blue: 227/255) : Color.clear)
                            .border(Color(red: 0.32, green: 0.23, blue: 0.06), width: selectedBooks.contains(book.id) ? 2 : 0)
                            
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Center the table
                }
            }
            .onAppear {
                // Fetch books from DataController
                fetchBooks()
            }
            .navigationTitle("Books Catalogues")
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        // Use this for better iPad support
    }


private func fetchBooks() {
    // Call DataController to fetch books asynchronously
    DataController.shared.fetchBooks { result in
        switch result {
        case .success(let fetchedBooks):
            // Update local state with fetched books
            self.books = fetchedBooks
        case .failure(let error):
            print("Failed to fetch books: \(error.localizedDescription)")
            // Handle error as needed
        }
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BooksCatalogue1()
    }
}
