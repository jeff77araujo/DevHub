//
//  SearchView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/03/26.
//

//
//  SearchView.swift
//  DevHub
//
//  Sprint 4.2: Busca de Repositórios
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Search Bar
                
                HStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField("Buscar repositórios...", text: $viewModel.searchText)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled()
                        
                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.clearSearch()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Filters button
                    Button {
                        viewModel.showFilters = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title3)
                                .foregroundStyle(viewModel.filters.hasActiveFilters ? .white : AppTheme.Colors.primary)
                                .frame(width: 44, height: 44)
                                .background(
                                    viewModel.filters.hasActiveFilters ?
                                    AppTheme.Colors.primary : Color(.systemGray6)
                                )
                                .cornerRadius(10)
                            
                            if viewModel.filters.hasActiveFilters {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Divider()
                
                // MARK: - Content
                
                if viewModel.searchText.isEmpty {
                    searchHistoryView
                } else if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else if viewModel.repositories.isEmpty {
                    emptyView
                } else {
                    resultsView
                }
            }
            .navigationTitle("Buscar")
            .sheet(isPresented: $viewModel.showFilters) {
                SearchFiltersView(viewModel: viewModel)
                    .presentationDetents([.medium])
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
        }
    }
    
    // MARK: - Search History View
    
    private var searchHistoryView: some View {
        VStack(spacing: 0) {
            if viewModel.searchHistory.isEmpty {
                ContentUnavailableView(
                    "Nenhuma busca recente",
                    systemImage: "clock.arrow.circlepath",
                    description: Text("Suas buscas aparecerão aqui")
                )
            } else {
                List {
                    Section {
                        ForEach(viewModel.searchHistory) { history in
                            Button {
                                viewModel.selectHistoryItem(history)
                            } label: {
                                HStack {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .foregroundStyle(.secondary)
                                    
                                    Text(history.query)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Button {
                                        viewModel.removeFromHistory(history)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    } header: {
                        HStack {
                            Text("Histórico")
                            
                            Spacer()
                            
                            Button("Limpar") {
                                viewModel.clearHistory()
                            }
                            .font(.caption)
                            .foregroundStyle(AppTheme.Colors.primary)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
    
    // MARK: - Results View
    
    private var resultsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.repositories) { repo in
                    RepoCard(
                        repository: repo,
                        onTap: { print("Tapped: \(repo.name)") },
                        onFavorite: { viewModel.toggleFavorite(repo, modelContext: modelContext) }
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .refreshable {
            if !viewModel.searchText.isEmpty {
                await viewModel.performSearch(query: viewModel.searchText)
                viewModel.updateFavoriteStates(modelContext: modelContext)
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Buscando...")
                .foregroundStyle(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Error View
    
    private func errorView(_ message: String) -> some View {
        ContentUnavailableView(
            "Erro na busca",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }
    
    // MARK: - Empty View
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            ContentUnavailableView(
                "Nenhum resultado",
                systemImage: "magnifyingglass",
                description: Text("Tente buscar com outros termos")
            )
            
            Button {
                viewModel.clearSearch()
            } label: {
                Text("Limpar Busca")
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.Colors.primary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SearchView()
        .withAuth()
        .modelContainer(for: SearchHistory.self, inMemory: true)
}
