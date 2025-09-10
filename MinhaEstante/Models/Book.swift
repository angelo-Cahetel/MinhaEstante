//
//  Book.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 10/09/25.
//
import Foundation

// Enum para o status do livro na estante
enum BookStatus: String, Codable, CaseIterable {
    case reading = "Lendo"
    case toRead = "Quero Ler"
    case finished = "Lido"
}

// Estrutura principal do livro
struct Book: Identifiable, Codable {
    let id: UUID
    var title: String
    var author: String
    var coverImageURL: URL? // opcional, para a capa do livro
    var totalPages: Int
    var Status: BookStatus
    
//    acompanhamento de leitura
    var readingSessions: [ReadingSession] = []
    var rating: Int? // de 1 a 5
    var review: String?
    
    var currentPage: Int {
        readingSessions.map(\.pagesRead).reduce(0, +)
    }
    
    var readingProgress: Double {
        totalPages > 0 ? Double(currentPage) / Double(totalPages) : 0
    }
    
    init(id: UUID = UUID(), title: String, author: String, totalPages: Int, status: BookStatus = .toRead) {
        self.id = id
        self.title = title
        self.author = author
        self.totalPages = totalPages
        self.Status = status
    }
}
