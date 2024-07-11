import SwiftUI
import Firebase
import FirebaseDatabase
import Combine
import FirebaseAuth






struct AddLibrarian: View {
    @StateObject private var viewModel = LibrarianViewModel()
    @State private var selectedLibrarian: Librarian?
    @State private var showSheet = false
    @State var menuOpened = false

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    func toggleMenu() {
        menuOpened.toggle()
    }
    var body: some View {
        VStack(spacing: 0) {
           
            
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("Manage Librarians")
                        .font(Font.custom("DM Sans", size: 48).weight(.medium))
                        .foregroundColor(.black)
                        .padding(.top, 15)
                        .padding(.leading, 64)
                        .padding(.bottom, 20)
                    Spacer()
                }
            }
            
            ScrollView{
                LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.librarians, id: \.email) { librarian in
                    LibrarianCard(librarian: librarian, selectedLibrarian: $selectedLibrarian, showSheet: $showSheet)
                }
            }
        }
            .padding(.horizontal, 18)
            .padding(.top, 25)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 19))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.BackgroundsGroupedPrimary)
        .sheet(isPresented: Binding(
            get: { showSheet },
            set: { showSheet = $0 }
        )) {
            if let selectedLibrarian = selectedLibrarian {
                LibrarianDetailView(librarian: selectedLibrarian, showSheet: $showSheet)
            }
        }
       
    }
}


struct AddLibrarian_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddLibrarian()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Portrait Preview")
            
            AddLibrarian()
                .previewLayout(.fixed(width: 1024, height: 768))
                .previewDisplayName("Landscape Preview")
        }
    }
}
