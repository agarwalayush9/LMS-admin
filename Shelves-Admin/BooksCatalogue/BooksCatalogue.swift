import SwiftUI



struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UIView {
        let containerView = UIView()
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.backgroundImage = UIImage() // Removes the top and bottom lines

        // Set background color
        searchBar.barTintColor = UIColor(red: 255/255, green: 246/255, blue: 227/255, alpha: 1.0)
        searchBar.searchTextField.backgroundColor = UIColor(.bookCatlogueSearchBar)
        
        searchBar.placeholder = "Search by Book Code, Book or Author"
        
        // Customize search icon color
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = searchTextField.leftView as? UIImageView {
                leftView.tintColor = UIColor(red: 0.32, green: 0.23, blue: 0.06, alpha: 1.0)
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            }
            // Add border to the search text field
            searchTextField.layer.borderColor = UIColor(red: 0.32, green: 0.23, blue: 0.06, alpha: 1.0).cgColor
            searchTextField.layer.borderWidth = 2.0
            searchTextField.layer.cornerRadius = 10.0
            searchTextField.layer.masksToBounds = true
        }
        
        containerView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: containerView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        // Set containerView height
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SearchBar>) {
        if let searchBar = uiView.subviews.first as? UISearchBar {
            searchBar.text = text
        }
    }
}




struct EditBookDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var editedBook: Book

    init(book: Book) {
        _editedBook = State(wrappedValue: book)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Details")) {
                    HStack {
                        Text("ISBN Code:")
                            .fontWeight(.bold)
                        TextField("ISBN Code", text: $editedBook.bookCode)
                    }
                    HStack {
                        Text("Book Title:")
                            .fontWeight(.bold)
                        TextField("Book Title", text: $editedBook.bookTitle)
                    }
                    HStack {
                        Text("Author:")
                            .fontWeight(.bold)
                        TextField("Author", text: $editedBook.author)
                    }
                }

                Section(header: Text("Additional Details")) {
                    HStack {
                        Text("Issued Date:")
                            .fontWeight(.bold)
                        TextField("Issued Date", text: $editedBook.issuedDate)
                    }
                    HStack {
                        Text("Return Date:")
                            .fontWeight(.bold)
                        TextField("Return Date", text: $editedBook.returnDate)
                    }
                    HStack {
                        Text("Quantity:")
                            .fontWeight(.bold)
                        TextField("Quantity", value: $editedBook.quantity, formatter: NumberFormatter())
                    }

                    if let url = URL(string: editedBook.bookCover) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 150, height: 200)
                    }
                }

                Section(header: Text("Book Status")) {
                    Picker("Status", selection: $editedBook.status) {
                        Text("Available").tag("Available")
                        Text("Not Available").tag("Not Available")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Button(action: {
                    // Update book details using DataController
                    // Dismiss edit view
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.32, green: 0.23, blue: 0.06))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Edit Book Details")
        }
    }
}

struct BooksCatalogue: View {
    @State private var selectedBooks = Set<UUID>()
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = []
    @State private var menuOpened = false
    @State private var isLoading = false
    @State private var selectedBook: Book?
    @State private var searchText = ""
    @State private var selectedGenre: Genre? = nil

    var filteredBooks: [Book] {
        var filtered = books
        
        // Apply genre filter if selected
        if let genre = selectedGenre {
            filtered = filtered.filter { $0.genre == genre }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.bookTitle.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText) ||
                $0.bookCode.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                            .frame(height: 70)
                        
                        // Genre filter dropdown
                        Menu {
                            Button("Clear Filter") {
                                selectedGenre = nil
                            }
                            Divider()
                            ForEach(Genre.allCases, id: \.self) { genre in
                                Button(genre.rawValue.capitalized) {
                                    selectedGenre = genre
                                }
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        .padding(.trailing, 20)
                        .foregroundColor(.filter)
                    }
                    ZStack {
                        backgroundView()
                            .blur(radius: menuOpened ? 10 : 0)
                            .animation(.easeInOut(duration: 0.25), value: menuOpened)

                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                headerRow()
                                    .padding(.top)
                                
                                ForEach(filteredBooks) { book in
                                    bookRow(book)
                                        .background(selectedBooks.contains(book.id) ? Color(red: 255/255, green: 246/255, blue: 227/255) : Color.clear)
                                        .border(Color(red: 0.32, green: 0.23, blue: 0.06), width: selectedBooks.contains(book.id) ? 2 : 0)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            toggleSelection(for: book)
                                        }
                                        .onLongPressGesture {
                                            selectedBook = book
                                        }
                                        .transition(.scale)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .refreshable {
                            await refreshBooks()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)

                if menuOpened {
                    sideMenu(width: UIScreen.main.bounds.width * 0.30, menuOpened: menuOpened, toggleMenu: toggleMenu)
                        .ignoresSafeArea()
                        .toolbar(.hidden, for: .navigationBar)
                }

                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding().frame(width: 140, height: 80)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }

//                floatingAddButton()
            }
            .navigationTitle("Book Catalogue".capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            menuOpened.toggle()
                        }
                    }) {
                        Image(systemName: "sidebar.left")
                            .foregroundColor(.mainFont)
                    }
                }
            }
            .onAppear {
                Task {
                    await fetchBooks()
                }
            }

            .sheet(item: $selectedBook) { book in
                EditBookDetailView(book: book)
                    .onDisappear {
                        if let index = books.firstIndex(where: { $0.id == book.id }) {
                            books[index] = selectedBook ?? book
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
    }



    private func headerRow() -> some View {
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
        .frame(maxWidth: .infinity)
        .transition(.slide)
    }

    private func bookRow(_ book: Book) -> some View {
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
                .frame(maxWidth: .infinity, alignment: .center)
            AsyncImageLoader(url: book.bookCover)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(book.bookTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(book.author)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(book.genre.rawValue)
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
                    selectedBook = book
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .frame(width: 70, alignment: .center)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: 80, alignment: .leading)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .transition(.slide)
    }

    private func refreshBooks() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        await fetchBooks()
        isLoading = false
    }

    private func fetchBooks() async {
        isLoading = true
        await DataController.shared.fetchBooks { result in
            switch result {
            case .success(let fetchedBooks):
                self.books = fetchedBooks
            case .failure(let error):
                print("Failed to fetch books: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }

    private func toggleMenu() {
        menuOpened.toggle()
    }

    private func toggleSelection(for book: Book) {
        if selectedBooks.contains(book.id) {
            selectedBooks.remove(book.id)
        } else {
            selectedBooks.insert(book.id)
        }
    }
}

struct BookDetailsView: View {
    let book: Book

    var body: some View {
        VStack(spacing: 20) {
            Text(book.bookTitle)
                .font(.largeTitle)
                .padding()

            AsyncImageLoader(url: book.bookCover)
                .frame(width: 150, height: 200)

            Text("Author: \(book.author)")
            Text("Genre: \(book.genre.rawValue)")
            Text("Issued Date: \(book.issuedDate)")
            Text("Return Date: \(book.returnDate)")
            Text("Status: \(book.status)")
                .foregroundColor(book.status == "Issued" ? .red : .green)
            Text("Quantity: \(book.quantity ?? 1)")

            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BooksCatalogue()
    }
}
