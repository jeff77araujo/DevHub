//
//  ReposViewModel.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import Foundation
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
    
    // MARK: - Toggle Favorite
    func toggleFavorite(repository: Repository) {
        if let index = repositories.firstIndex(where: { $0.id == repository.id }) {
            repositories[index].isFavorite.toggle()
            
            // TODO: Salvar no SwiftData
            print("Favorited: \(repositories[index].name) - \(repositories[index].isFavorite)")
        }
    }
}

