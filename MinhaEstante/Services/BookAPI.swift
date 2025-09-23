//
//  BookAPI.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 23/09/25.
//
import Foundation

// representa possiveis erros de rede
enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingError
}

class googleBooksAPI {
    
    private let url = "https://www.googleapis.com/books/v1/volumes"
    
    func searchBooks(query: String) async throws -> [Book] {
        // monta URL de forma segura
        guard var components = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }
        
//        adiciona o parâmetro de busca
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
//        faz a chamada de rede
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
//            decodificar a resposta JSON
            let decoder = JSONDecoder()
            let bookResponse = try decoder.decode(BookResponse.self, from: data)
            
            return bookResponse.items
        } catch {
//            se a requisição der erro
            throw NetworkError.requestFailed
        }
    }
}
