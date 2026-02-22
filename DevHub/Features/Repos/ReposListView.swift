//
//  ReposListView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import SwiftUI

struct ReposListView: View {
    @StateObject private var viewModel = ReposViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    // Loading inicial
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.medium) {
                            ForEach(0..<5, id: \.self) { _ in
                                RepoCardSkeleton()
                            }
                        }
                        .padding()
                    }
                } else if let error = viewModel.errorMessage, viewModel.repositories.isEmpty {
                    // Erro
                    EmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Erro ao carregar",
                        message: error,
                        action: (
                            title: "Tentar Novamente",
                            icon: "arrow.clockwise",
                            color: nil,
                            action: {
                                Task { await viewModel.fetchTrending() }
                            }
                        )
                    )
                } else if viewModel.repositories.isEmpty {
                    // Empty
                    EmptyState(
                        icon: "folder",
                        title: "Nenhum repositório",
                        message: "Não encontramos repositórios para exibir"
                    )
                } else {
                    // Lista de repos
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.medium) {
                            ForEach(viewModel.repositories) { repo in
                                RepoCard(
                                    repository: repo,
                                    onTap: {
                                        // TODO: Navegar para detalhes
                                        print("Tapped: \(repo.name)")
                                    },
                                    onFavorite: {
                                        viewModel.toggleFavorite(repository: repo)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Trending")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await viewModel.fetchTrending()
        }
    }
}

#Preview("Com Dados") {
    let viewModel = ReposViewModel(
        reposService: MockGitHubReposService()
    )
    viewModel.repositories = Repository.mocks
    
    return NavigationStack {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.medium) {
                    ForEach(Repository.mocks) { repo in
                        RepoCard(
                            repository: repo,
                            onTap: { print("Tapped") },
                            onFavorite: { print("Favorited") }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Trending")
    }
    .withAuth()
}
// MARK: - Previews
#Preview("Loading") {
    NavigationStack {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTheme.Spacing.medium) {
                    ForEach(0..<5, id: \.self) { _ in
                        RepoCardSkeleton()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Trending")
    }
    .withAuth()
}

#Preview("Dark Mode") {
    let viewModel = ReposViewModel(
        reposService: MockGitHubReposService()
    )
    viewModel.repositories = Repository.mocks
    
    return NavigationStack {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.medium) {
                    ForEach(Repository.mocks) { repo in
                        RepoCard(
                            repository: repo,
                            onTap: { print("Tapped") },
                            onFavorite: { print("Favorited") }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Trending")
    }
    .withAuth()
    .preferredColorScheme(.dark)
}
