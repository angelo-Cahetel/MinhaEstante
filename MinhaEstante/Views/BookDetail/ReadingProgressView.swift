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
    var body: some View {
        VStack(alignment: .leading) {
            Text("Progresso").font(.headline)
            ProgressView(value: book.readingProgress)
            HStack {
                Text("Página \(book.currentPage)")
                Spacer()
                Text("\(Int(book.readingProgress * 100))%")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }

    }
}
