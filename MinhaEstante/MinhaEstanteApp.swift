//
//  MinhaEstanteApp.swift
//  MinhaEstante
//
//  Created by Ângelo Mendes on 10/09/25.
//

import SwiftUI
import SwiftData

@main
struct MinhaEstanteApp: App {
    @StateObject private var viewModel = LibraryViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
