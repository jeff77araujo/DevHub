//
//  PreviewHelper.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import SwiftUI

#if DEBUG

// MARK: - Mock Services

final class MockGitHubReposService: GitHubReposServiceProtocol {
    var shouldFail = false
    var repos: [Repository] = Repository.mocks
    
    func fetchTrendingRepos() async throws -> [Repository] {
        if shouldFail {
            throw RepositoryError.invalidResponse
        }
        try? await Task.sleep(for: .milliseconds(500))
        return repos
    }
    
    func fetchUserRepos(username: String) async throws -> [Repository] {
        if shouldFail {
            throw RepositoryError.invalidResponse
        }
        try? await Task.sleep(for: .milliseconds(500))
        return repos
    }
}

// MARK: - Preview Extensions

extension View {
    func withAuth() -> some View {
        self.environmentObject(AuthService.mock())
    }
}

#endif
