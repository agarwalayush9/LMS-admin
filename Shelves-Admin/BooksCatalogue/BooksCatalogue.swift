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
    var books: [Book] // Pass existing books

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
                    .keyboardType(.numberPad) // Ensure numeric keyboard
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
                    // Validate quantity input
                    guard let quantityValue = Int(quantity) else {
                        alertMessage = "Please enter a valid numeric quantity."
                        showAlert = true
                        return
                    }
                    
                    // Check if the book already exists
                    if books.contains(where: { $0.bookTitle == bookTitle && $0.author == author }) {
                        alertMessage = "A book with the same title and author already exists."
                        showAlert = true
                        return
                    }

                    let newBook = Book(
                        bookCode: "978-\(Int.random(in: 1000000...9999999))", // Generate random ISBN
                        bookCover: "book_cover",
                        bookTitle: bookTitle.isEmpty ? "Unknown Title" : bookTitle,
                        author: author.isEmpty ? "Unknown Author" : author,
                        genre: [genre],
                        issuedDate: "2024-05-01",
                        returnDate: "2024-06-01",
                        status: "Available",
                        quantity: quantityValue
                    )


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
        .frame(maxWidth: 500) // Limit the width of the pop-up
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

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

struct BooksCatalogue: View {
    @State private var selectedBooks = Set<UUID>()
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = [] // Use @State to hold fetched books
    @State var menuOpened = false
    
    var body: some View {
        NavigationStack {
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
                        .padding(.top, 10)
                    }
                    .padding(.top, 10)
                }
                .onAppear {
                    // Fetch books from DataController
                    fetchBooks()
                }
                if menuOpened {
                    sideMenu( width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                }
            }
            
        .navigationTitle("LMS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    menuOpened.toggle()
                }, label: {
                    Image(systemName: "sidebar.left")
                        .foregroundStyle(Color.black)
                })
                
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    
                }, label: {
                    Image(systemName: "books.vertical")
                        .foregroundColor(Color.black)
                })
            }
        }
            
        }
        .navigationBarBackButtonHidden(true)
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
    func toggleMenu() {
        menuOpened.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BooksCatalogue()
    }
}
