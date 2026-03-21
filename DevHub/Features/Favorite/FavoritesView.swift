//
//  FavoritesView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 15/03/26.
//

import SwiftUI
import SwiftData

// MARK: - Wrapper View (pega modelContext)

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        FavoritesContentView(modelContext: modelContext)
    }
}

// MARK: - Content View (observa ViewModel)

private struct FavoritesContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: FavoritesViewModel
    
    init(modelContext: ModelContext) {
        let service = FavoritesService()  // ✅ Sem parâmetro!
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(favoritesService: service))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else if viewModel.favorites.isEmpty {
                    emptyStateView
                } else if viewModel.filteredFavorites.isEmpty && !viewModel.searchText.isEmpty {
                    searchEmptyView
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favoritos")
            .searchable(
                text: $viewModel.searchText,
                prompt: "Buscar repositórios"
            )
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.updateSearch(newValue)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortMenu
                }
            }
        }
        .task {
            viewModel.loadFavorites(context: modelContext)
        }
        .refreshable {
            viewModel.loadFavorites(context: modelContext)
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            ProgressView()
            Text("Carregando favoritos...")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.secondary)
        }
    }
    
    private func errorView(_ message: String) -> some View {
        EmptyState(
            icon: "exclamationmark.triangle.fill",
            title: "Erro",
            message: message,
            action: (
                title: "Tentar Novamente",
                icon: "arrow.clockwise",
                color: nil,
                action: { viewModel.loadFavorites(context: modelContext) }
            )
        )
    }
    
    private var emptyStateView: some View {
        EmptyState(
            icon: "star.slash.fill",
            title: "Nenhum Favorito",
            message: "Você ainda não favoritou nenhum repositório.\n\nExplore a aba Repositórios e favorite seus projetos preferidos!",
            action: nil
        )
    }
    
    private var searchEmptyView: some View {
        EmptyState(
            icon: "magnifyingglass",
            title: "Sem Resultados",
            message: "Nenhum repositório encontrado para \"\(viewModel.searchText)\"",
            action: (
                title: "Limpar Busca",
                icon: "xmark.circle",
                color: AppTheme.Colors.secondary,
                action: { viewModel.clearSearch() }
            )
        )
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.medium) {
                ForEach(viewModel.filteredFavorites) { repo in
                    RepoCard(
                        repository: repo,
                        onTap: { print("Tapped \(repo.name)") },
                        onFavorite: {
                            viewModel.removeFavorite(repo, context: modelContext)
                        }
                    )
                    .padding(.horizontal, AppTheme.Spacing.medium)
                }
            }
            .padding(.vertical, AppTheme.Spacing.medium)
        }
    }
    
    private var sortMenu: some View {
        Menu {
            ForEach(FavoritesViewModel.SortOption.allCases, id: \.self) { option in
                Button {
                    viewModel.updateSort(option)
                } label: {
                    Label(
                        option.rawValue,
                        systemImage: option.systemImage
                    )
                }
                .disabled(viewModel.sortOption == option)
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .font(.title3)
                .foregroundStyle(AppTheme.Colors.primary)
        }
    }
}

// MARK: - Preview

#Preview("Com Favoritos") {
    MainTabView()
        .withAuth()
        .modelContainer(for: FavoriteRepository.self, inMemory: true)
}

#Preview("Vazio") {
    FavoritesView()
        .modelContainer(for: FavoriteRepository.self, inMemory: true)
}

#Preview("Dark Mode") {
    FavoritesView()
        .modelContainer(for: FavoriteRepository.self, inMemory: true)
        .preferredColorScheme(.dark)
}
