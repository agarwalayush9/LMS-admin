//
//  BooksCatalogue.swift
//  Shelves-Admin
//
//  Created by Mohit Kumar Gupta on 04/07/24.
//

//import SwiftUI
//
//struct Book: Identifiable {
//    let id = UUID()
//    let title: String
//    let author: String
//    let category: String
//    let imageName: String
//}
//
//struct LibraryView: View {
//    let books: [Book] = [
//        Book(title: "1984", author: "George Orwell", category: "Dystopic", imageName: "1984"),
//        Book(title: "1984", author: "George Orwell", category: "Dystopic", imageName: "1984"),
//        Book(title: "1984", author: "George Orwell", category: "Dystopic", imageName: "1984"),
//        Book(title: "1984", author: "George Orwell", category: "Dystopic", imageName: "1984"),
//        Book(title: "1984", author: "George Orwell", category: "Dystopic", imageName: "1984"),
//        Book(title: "1984", author: "George Orwell", category: "Dystopic", imageName: "1984"),
//        
//    ]
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let isPortrait = geometry.size.width < geometry.size.height
//            let columns = isPortrait ? [
//                GridItem(.flexible()),
//                GridItem(.flexible())
//            ] : [
//                GridItem(.flexible()),
//                GridItem(.flexible()),
//                GridItem(.flexible())
//            ]
//            
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("Library")
//                        .font(.largeTitle)
//                    Spacer()
//                    Button(action: {
//                        // Action for add button
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                }
//                .padding()
//                
//                Text("\(books.count) books")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
//                
//                ScrollView {
//                    LazyVGrid(columns: columns) {
//                        ForEach(books) { book in
//                            HStack(alignment: .center, spacing: 20) {
//                                Image(book.imageName)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 150)
//                                    .cornerRadius(8)
//                                VStack(alignment: .leading) {
//                                    Spacer()
//                                    HStack(alignment: .center, spacing: 13.19307) {
//                                        Text("#4235532")
//                                        .font(
//                                        Font.custom("DM Sans", size: 12)
//                                        .weight(.medium)
//                                        )
//                                        .foregroundColor(.black)
//                                    }
//                                    .padding(.horizontal, 5.27723)
//                                    .padding(.vertical, 2.63861)
//                                    .frame(width: 75.77228, alignment: .center)
//                                    .background(Color(red: 0.91, green: 0.95, blue: 0.99))
//
//                                    .cornerRadius(9.23515)
//                                    Text(book.title)
//                                        .font(.headline)
//                                    Text(book.author)
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                    Text(book.category)
//                                        .font(.caption)
//                                        .foregroundColor(.secondary)
//                                    Spacer()
//                                    HStack {
//                                        Image(systemName: "bookmark.fill")
//                                            .foregroundColor(.yellow)
//                                        Spacer()
//                                    }
//                                }
//                            }
//                            .padding()
//                            .background(Color(.white))
//                            .cornerRadius(10)
//                            .shadow(radius: 3)
//                        }
//                        .padding(10)
//                    }
//                    .padding()
//                }
//            }
//            .background(Color(red: 0.949, green: 0.949, blue: 0.969))
//        }
//    }
//}
//
//struct BooksCatalogue: View {
//    var body: some View {
//        LibraryView()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BooksCatalogue()
//    }
//}
