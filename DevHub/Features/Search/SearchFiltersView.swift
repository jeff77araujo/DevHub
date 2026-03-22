//
//  SearchFiltersView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/03/26.
//

import SwiftUI

struct SearchFiltersView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Language Section
                
                Section("Linguagem") {
                    Picker("Selecione uma linguagem", selection: languageBinding) {
                        ForEach(SearchFilters.Language.allCases) { language in
                            Text(language.displayName)
                                .tag(language.rawValue.isEmpty ? nil as String? : language.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // MARK: - Stars Section
                
                Section("Stars mínimas") {
                    Picker("Selecione", selection: starsBinding) {
                        ForEach(SearchFilters.StarsFilter.allCases) { stars in
                            Text(stars.displayName)
                                .tag(stars.rawValue == 0 ? nil as Int? : stars.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // MARK: - Sort Section
                
                Section("Ordenação") {
                    Picker("Ordenar por", selection: $viewModel.filters.sortBy) {
                        ForEach(SearchFilters.SortOption.allCases) { option in
                            Text(option.rawValue)
                                .tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                // MARK: - Reset Section
                
                Section {
                    Button(role: .destructive) {
                        viewModel.resetFilters()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Resetar Filtros")
                        }
                    }
                }
            }
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aplicar") {
                        dismiss()
                        
                        // Re-executar busca com novos filtros
                        if !viewModel.searchText.isEmpty {
                            Task {
                                await viewModel.performSearch(query: viewModel.searchText)
                            }
                        }
                    }
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Bindings
    
    private var languageBinding: Binding<String?> {
        Binding(
            get: { viewModel.filters.language },
            set: { viewModel.filters.language = $0 }
        )
    }
    
    private var starsBinding: Binding<Int?> {
        Binding(
            get: { viewModel.filters.minStars },
            set: { viewModel.filters.minStars = $0 }
        )
    }
}

// MARK: - Preview

#Preview {
    SearchFiltersView(viewModel: SearchViewModel())
}
