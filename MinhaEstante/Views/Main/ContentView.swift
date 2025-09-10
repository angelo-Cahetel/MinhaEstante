//
//  ContentView.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 10/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @State private var showingAddBookSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(BookStatus.allCases, id: \.self) { status in
                    Section(header: Text(status.rawValue).font(.headline)) {
                        let filteredBooks = viewModel.books(for: status)
                        if filteredBooks.isEmpty {
                            Text("Nenhum livro na estante.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(filteredBooks) { book in
                                NavigationLink(destination: BookDetailView(book: binding(for: book))) {
                                    BookRowView(book: book)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Minha Estante"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBookSheet = true}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddBookSheet) {
                AddBookView()
                    .environmentObject(viewModel)
            }
        }
    }
    
//    cria biding para livro específico no array
    private func binding(for book: Book) -> Binding<Book> {
        guard let bookIndex = viewModel.books.firstIndex(where: { $0.id == book.id}) else {
            fatalError("Livro não encontrado")
        }
        return $viewModel.books[bookIndex]
    }
}

struct BookView: View {
    let book: Book
    
    var body: some View {
        HStack {
//            placeholder para a capa do livro
            Image(systemName: "book.closed.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 60)
                .foregroundColor(.blue)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(book.title).font(.headline)
                Text(book.author).font(.subheadline).foregroundColor(.secondary)
                if book.status == .reading {
                    ProgressView(value: book.readingProgress)
                    Text("Página \(book.currentPage) de \(book.totalPages)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
