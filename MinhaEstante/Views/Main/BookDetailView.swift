//
//  BookDetailView.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 10/09/25.
//

import SwiftUI

struct BookDetailView: View {
    @Binding var book: Book
    @EnvironmentObject var viewModel: LibraryViewModel
    @State private var showingLogSessionSheet: Bool = false
    @State private var showingReviewSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
//                Seção de informação
                HStack(alignment: .top) {
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(book.title).font(.largeTitle).bold()
                        Text(book.author).font(.title3).foregroundColor(.secondary)
                        Text("\(book.totalPages) Páginas").font(.subheadline)
                    }
                }
                
//                seção de progresso
                VStack(alignment: .leading) {
                    Text("Progresso").font(.headline)
                    ProgressView(value: book.readingProgress)
                    HStack {
                        Text("Página \(book.currentPage)")
                        Spacer()
                        Text("\(Int(book.readingProgrees * 100))%")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
//                Botão de ação
                HStack {
                    if book.status == .toRead {
                        Button("Começar a Ler") {
                            viewModel.startReading(bookId: book.id)
                        }
                        .buttonStyle(.borderedProminent)
                    } else if book.status == .reading {
                        Button("Registrar Leitura") {
                            showingLogSessionSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Finalizar e Avaliar") {
                            showingReviewSheet = true
                        }
                        .buttonStyle(.bordered)
                    }
                }
//                Seção de seções de leitura
            }
        }
    }
}

#Preview {
    BookDetailView()
}
