import SwiftUI



struct BooksCatalogue: View {
    @State private var selectedBooks = Set<UUID>()
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = [] // Use @State to hold fetched books
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BooksCatalogue()) {
                    Label("Shelves Library", systemImage: "books.vertical")
                        .font(.title)
                        .foregroundColor(.brown)
                }
                NavigationLink(destination: BooksCatalogue()) {
                    Label("Book Catalogues", systemImage: "book")
                        .font(.title2)
                        .foregroundColor(.brown)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Shelves Library")
            
            ZStack {
                VStack {
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
                

            }
            .onAppear {
                // Fetch books from DataController
                fetchBooks()
            }
            .navigationTitle("Books Catalogues")
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
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
        BooksCatalogue()
    }
}
