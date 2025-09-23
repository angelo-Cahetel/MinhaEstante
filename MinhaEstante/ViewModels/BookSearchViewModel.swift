//
//  BookSearchViewModel.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 23/09/25.
//

import SwiftUI

@MainActor
class BookSearchViewModel: ObservableObject {
    
    @Published var searchTerm: String = ""
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service = googleBooksAPI()
    
    func executeSearch() async {
//        limpa mensagem de erro anterior e inicia o carregamento
        errorMessage = nil
        isLoading = true
        
//        garande que o estado de carregamento seja finalizado ao sair da função
        defer {
            isLoading = false
        }
        
        do {
//            chama o serviço de rede e atualiza a lista de livros
            let foundBooks = try await service.searchBooks(query: searchTerm)
            self.books = foundBooks
        } catch {
//            em caso de erro atualiza a mensagem
            self.errorMessage = "Falha ao buscar livros. Tente novamente."
        }
    }
}
