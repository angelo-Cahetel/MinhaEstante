//
//  ReadingProgressView.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 15/09/25.
//
import Foundation
import SwiftUI

struct ReadingProgressView: View {
    let book: Book
    
    private var pagesReadSoFar: Int {
        book.readingSessions.reduce(0) { $0 + $1.pagesRead }
    }
    
    private var progress: Double {
        guard book.totalPages > 0 else { return 0 }
        return min(Double(pagesReadSoFar) / Double(book.totalPages), 1.0)
    }
    
    private var currentPageDerived: Int {
        min(pagesReadSoFar, book.totalPages)
    }
    
    var body: some View {
        let totalRead = book.readingSessions.reduce(0) {$0 + $1.pagesRead }
        let progress = book.totalPages > 0 ? Double(totalRead) / Double(book.totalPages) : 0
        VStack(alignment: .leading) {
            Text("Progresso").font(.headline)
            ProgressView(value: progress)
            HStack {
                Text("Página \(currentPageDerived)")
                Spacer()
                Text("\(Int(progress * 100))%")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }

    }
}

