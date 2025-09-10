//
//  AddBookView.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 10/09/25.
//

import SwiftUI

struct AddBookView: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var totalPages: String = ""
    
    var body: some View {
        NavigationView {
            Section(header: Text("Detalhes do Livro")) {
                TextField("Título", text: $title)
                TextField("Autor(a)", text: $author)
                TextField("Número de Páginas", text: $totalPages)
                    .keyboardType(.numberPad)
            }
            
            Button("Adicionar à Estante") {
                if let pages = Int(totalPages) {
                    viewModel.addBook(title: title, author: author, totalPages: pages)
                    dismiss()
                }
            }
            .disabled(title.isEmpty || author.isEmpty || totalPages.isEmpty)
        }
        .navigationTitle("Adicionar Novo Livro")
        .navigationBarItems(leading: Button("Cancelar") { dismiss() })
    }
}

#Preview {
    AddBookView()
}
