//
//  BookDetailHeaderView.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 15/09/25.
//
import Foundation
import SwiftUI

struct BookDetailHeaderView: View {
    let book: Book
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "book.closed.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(book.title).font(.largeTitle).bold()
                Text(book.author).font(.title3).foregroundColor(.secondary)
                Text("\(book.totalPages) páginas").font(.subheadline)
            }
        }
    }
}
