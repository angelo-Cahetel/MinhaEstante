//
//  LibraryViewModel.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 10/09/25.
//

import SwiftUI

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var books: [Book] = [] {
        didSet {
            // salva os livros quando a lista é alterada
            saveBooks()
        }
    }
    
    private let userDefaultsKey = "myLibraryBooks"
    
    init() {
        // carrga os livros ao iniciar
        loadBooks()
    }
    
    //    MARK: - Public Methods
    // retorna livros filtrados por status
    func books(for status: BookStatus) -> [Book] {
        books.filter { $0.status == status }
    }
    
    /*
     adiciona um novo livro
     todo: adicionar o número de páginas automaticamente chamando da API
     */
    func addBook(title: String, author: String, totalPages: Int) {
        let newBook = Book(title: title, author: author, totalPages: totalPages, status: .toRead)
        books.append(newBook)
    }
    
    //    adiciona uma sessão de leitura a um livro
    func logReadingSession(for bookId: UUID, pagesRead: Int, date: Date = Date()) {
        guard let index = getIndex(for: bookId) else { return }
        var updated = books[index]
        updated.readingSessions.append(ReadingSession(date: date, pagesRead: pagesRead))
        books[index] = updated
    }
    
    //    adiciona uma resenha e avaliação
    func addReview(for bookId: UUID, rating: Int, reviewText: String) {
        guard let index = getIndex(for: bookId) else { return }
        books[index].rating = rating
        books[index].review = reviewText
        //        muda status para "Lido"
        books[index].status = .finished
    }
    
    // move um livro para a estante "Lendo atualmente"
    func startReading(bookId: UUID) {
        guard let index = getIndex(for: bookId) else { return }
        books[index].status = .reading
    }
    
//    MARK: - Private Helper Methods
    private func getIndex(for bookId: UUID) -> Int? {
        books.firstIndex(where: { $0.id == bookId })
    }
    
//    MARK: - Data Persistence
    /*  ---  persistencia de Dados (simples com UserDefaults) ---
     todo: adicionar CoreData
     */
    private func saveBooks() {
        if let encodeData = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encodeData, forKey: userDefaultsKey)
        }
    }
    
    private func loadBooks() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedBooks = try? JSONDecoder().decode([Book].self, from: savedData) {
            self.books = decodedBooks
        } else {
            //            adiciona dados de exemplo se não houver nada salvo
            self.books = [
                Book(title: "O Hobbit", author: "J.R.R Tolkien", totalPages: 310, status: .reading),
                Book(title: "Duna", author: "Frank Herbert", totalPages: 688, status: .toRead)
            ]
        }
    }
}

