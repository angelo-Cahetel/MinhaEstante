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
                BookDetailHeaderView(book: book)
                
//                seção de progresso
                ReadingProgressView(book: book)
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
//               MARK: - Seção de histórico de leitura
                VStack(alignment: .leading) {
                    Text("Histórico de Leitura").font(.headline)
                    if book.readingSessions.isEmpty {
                        Text("Nenhuma leitura registrada.").foregroundColor(.secondary)
                    } else {
                        ForEach(book.readingSessions.sorted(by: { $0.date > $1.date })) { session in
                            HStack {
                                Text(session.date, style: .date)
                                Spacer()
                                Text("\(session.pagesRead) páginas")
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
//                MARK: - Seção de Resenha
                if let rating = book.rating,
                   let review = book.review {
                    VStack(alignment: .leading) {
                        Text("Sua Avaliação").font(.headline)
                        HStack {
                            ForEach(1...5, id: \.self) { number in
                                Image(systemName: number > rating ? "star" : "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        Text(review)
                            .padding(.top, 4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingLogSessionSheet) {
            LogSessionView(book: $book)
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingReviewSheet) {
            ReviewView(book: $book)
                .environmentObject(viewModel)
        }
    }
}

// MARK: - view que registra leitura
struct LogSessionView: View {
    @Binding var book: Book
    @EnvironmentObject var viewModel: LibraryViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var pagesRead: String = ""
    @State private var sessionDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Data de Leitura", selection: $sessionDate, displayedComponents: .date)
                TextField("Páginas Lidas", text: $pagesRead)
                    .keyboardType(.numberPad)
                
                Button("Registrar") {
                    if let pages = Int(pagesRead) {
                        viewModel.logReadingSession(for: book.id, pagesRead: pages, date: sessionDate)
                        dismiss()
                    }
                }
                .disabled(pagesRead.isEmpty)
            }
            .navigationTitle("Fazer Histórico de Leitura")
            .navigationBarItems(leading: Button("Cancelar") { dismiss() })
        }
    }
}

// MARK: - View para escrever review
struct ReviewView: View {
    @Binding var book: Book
    @EnvironmentObject var viewModel: LibraryViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sua Avaliação")) {
                    HStack {
                        Text("Nota:")
                        Spacer()
//                        componente de estrelas
                        ForEach(1...5, id: \.self) { number in
                            Image(systemName: number > rating ? "star" : "star.fill")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = number
                                }
                        }
                    }
                }
                
                Section(header: Text("Sua Resenha")) {
                    TextEditor(text: $reviewText)
                        .frame(height: 200)
                }
                
                Button("Salvar Avaliação") {
                    viewModel.addReview(for: book.id, rating: rating, reviewText: reviewText)
                    dismiss()
                }
                .disabled(rating == 0 || reviewText.isEmpty)
            }
            .navigationTitle("Avaliar \(book.title)")
            .navigationBarItems(leading: Button("Cancelar") { dismiss() })
        }
    }
}

#Preview {
//    exemplo
    let mockBook = Book(
        title: "O Senhor dos Anéis",
        author: "J.R.R Tolkien",
        totalPages: 320,
        status: .reading
    )
//    passa o livro pra View usando .constant() para criar o Biding
    return BookDetailView(book: .constant(mockBook))
        .environmentObject(LibraryViewModel())
}
