//
//  DataController.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 06/07/24.
//

import Foundation
import FirebaseDatabase

class DataController
{
    var books: [Book] = []
    
    static let shared = DataController() // singleton
    private let database = Database.database().reference()
    
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
            database.child("books").observe(.value) { snapshot in
                guard let booksDict = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                    return
                }
                
                var books: [Book] = []
                
                for (_, dict) in booksDict {
                    guard
                        let bookCode = dict["bookCode"] as? String,
                        let bookCover = dict["bookCover"] as? String,
                        let bookTitle = dict["bookTitle"] as? String,
                        let author = dict["author"] as? String,
                        let genreStrings = dict["genre"] as? [String],
                        let issuedDate = dict["issuedDate"] as? String,
                        let returnDate = dict["returnDate"] as? String,
                        let status = dict["status"] as? String
                    else {
                        print("Failed to parse book data.")
                        continue
                    }
                    
                    // Convert genre strings to Genre enum array
                    let genres = genreStrings.compactMap { Genre(rawValue: $0) }
                    
                    let book = Book(
                        bookCode: bookCode,
                        bookCover: bookCover,
                        bookTitle: bookTitle,
                        author: author,
                        genre: genres,
                        issuedDate: issuedDate,
                        returnDate: returnDate,
                        status: status
                    )
                    
                    books.append(book)
                }
                
                print("Fetched \(books.count) books.")
                completion(.success(books))
            }
        }
    }
