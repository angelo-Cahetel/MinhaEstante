//
//  ReadingSession.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 10/09/25.
//
import Foundation

// Estrutura para uma sessão de leitura
struct ReadingSession: Identifiable, Codable {
    let id: UUID
    var date: Date
    var pagesRead: Int
    
    init(id: UUID = UUID(), date: Date = Date(), pagesRead: Int) {
        self.id = id
        self.date = date
        self.pagesRead = pagesRead
    }
}
