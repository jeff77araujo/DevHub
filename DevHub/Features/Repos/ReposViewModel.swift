//
//  ReposViewModel.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import Foundation
import SwiftData
internal import Combine

@MainActor
final class ReposViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let reposService: GitHubReposService
    
    // MARK: - Initialization
    init(reposService: GitHubReposService = GitHubReposService()) {
        self.reposService = reposService
    }
    
    // MARK: - Fetch Trending
    func fetchTrending() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let repos = try await reposService.fetchTrendingRepos()
            self.repositories = repos
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Fetch User Repos
    func fetchUserRepos(username: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let repos = try await reposService.fetchUserRepos(username: username)
            self.repositories = repos
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Refresh
    func refresh() async {
        await fetchTrending()
    }
    
    // MARK: - Update Favorite States
    
    /// Atualiza estados de favoritos comparando com SwiftData
    func updateFavoriteStates(modelContext: ModelContext) {
        let favoritesService = FavoritesService()
        
        repositories = repositories.map { repo in
            var mutableRepo = repo
            mutableRepo.isFavorite = favoritesService.isFavorite(
                repoId: repo.id,
                context: modelContext
            )
            return mutableRepo
        }
    }
    
    // MARK: - Toggle Favorite
    
    func toggleFavorite(_ repository: Repository, modelContext: ModelContext) {
        let favoritesService = FavoritesService()
        
        do {
            try favoritesService.toggleFavorite(repository, context: modelContext)
            print("✅ Favorito atualizado: \(repository.name)")
            
            // Atualizar UI imediatamente
            if let index = repositories.firstIndex(where: { $0.id == repository.id }) {
                repositories[index].isFavorite.toggle()
                print("  - \(repositories[index].isFavorite)")
            }
        } catch {
            print("❌ Erro ao favoritar: \(error)")
        }
    }
}
