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
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let reposService: GitHubReposServiceProtocol
    
    init(reposService: GitHubReposServiceProtocol = GitHubReposService()) {
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
    func updateFavoriteStates(modelContext: ModelContext) {
        let favoritesService = FavoritesService(modelContext: modelContext)
        
        repositories = repositories.map { repo in
            var mutableRepo = repo
            mutableRepo.isFavorite = favoritesService.isFavorite(repoId: repo.id)
            return mutableRepo
        }
    }
    
    // MARK: - Toggle Favorite
    func toggleFavorite(repository: Repository, modelContext: ModelContext) {
        let favoritesService = FavoritesService(modelContext: modelContext)
        
        // Atualizar UI imediatamente
        if let index = repositories.firstIndex(where: { $0.id == repository.id }) {
            repositories[index].isFavorite.toggle()
            
            // Salvar no SwiftData
            do {
                try favoritesService.toggleFavorite(repository)
                print("✅ Favorito atualizado: \(repository.name) - \(repositories[index].isFavorite)")
            } catch {
                // Reverter se falhar
                repositories[index].isFavorite.toggle()
                errorMessage = "Erro ao favoritar: \(error.localizedDescription)"
                print("❌ Erro ao favoritar: \(error)")
            }
        }
    }
}
