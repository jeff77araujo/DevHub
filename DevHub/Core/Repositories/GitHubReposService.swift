//
//  GitHubReposService.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import Foundation

protocol GitHubReposServiceProtocol {
    func fetchTrendingRepos() async throws -> [Repository]
    func fetchUserRepos(username: String) async throws -> [Repository]
}

final class GitHubReposService: GitHubReposServiceProtocol {
    private let keychainManager = KeychainManager.shared
    
    func fetchTrendingRepos() async throws -> [Repository] {
        guard let token = keychainManager.githubToken else {
            throw RepositoryError.notAuthenticated
        }
        
        let query = """
        query {
          search(query: "stars:>1000 sort:stars-desc", type: REPOSITORY, first: 20) {
            nodes {
              ... on Repository {
                id
                name
                description
                url
                stargazerCount
                forkCount
                primaryLanguage {
                  name
                  color
                }
                updatedAt
                owner {
                  login
                  avatarUrl
                }
              }
            }
          }
        }
        """
        
        return try await performGraphQLRequest(query: query, token: token, keyPath: ["search", "nodes"])
    }
    
    func fetchUserRepos(username: String) async throws -> [Repository] {
        guard let token = keychainManager.githubToken else {
            throw RepositoryError.notAuthenticated
        }
        
        let query = """
        query {
          user(login: "\(username)") {
            repositories(first: 20, orderBy: {field: STARGAZERS, direction: DESC}) {
              nodes {
                id
                name
                description
                url
                stargazerCount
                forkCount
                primaryLanguage {
                  name
                  color
                }
                updatedAt
                owner {
                  login
                  avatarUrl
                }
              }
            }
          }
        }
        """
        
        return try await performGraphQLRequest(query: query, token: token, keyPath: ["user", "repositories", "nodes"])
    }
    
    // MARK: - Private Helper
    
    private func performGraphQLRequest(
        query: String,
        token: String,
        keyPath: [String]
    ) async throws -> [Repository] {
        let url = URL(string: "https://api.github.com/graphql")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["query": query]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Parse response
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        // Navigate through keyPath
        var current: Any? = json?["data"]
        for key in keyPath {
            guard let dict = current as? [String: Any] else {
                throw RepositoryError.invalidResponse
            }
            current = dict[key]
        }
        
        guard let nodes = current as? [[String: Any]] else {
            throw RepositoryError.invalidResponse
        }
        
        return try nodes.compactMap { try parseRepository(from: $0) }
    }
    
    private func parseRepository(from json: [String: Any]) throws -> Repository? {
        guard let id = json["id"] as? String,
              let name = json["name"] as? String,
              let urlString = json["url"] as? String,
              let url = URL(string: urlString),
              let ownerDict = json["owner"] as? [String: Any],
              let ownerLogin = ownerDict["login"] as? String else {
            return nil
        }
        
        let description = json["description"] as? String
        let stargazerCount = json["stargazerCount"] as? Int ?? 0
        let forkCount = json["forkCount"] as? Int ?? 0
        
        let language = (json["primaryLanguage"] as? [String: Any])?["name"] as? String
        let languageColor = (json["primaryLanguage"] as? [String: Any])?["color"] as? String
        
        let ownerAvatarURLString = ownerDict["avatarUrl"] as? String
        let ownerAvatarURL = ownerAvatarURLString.flatMap { URL(string: $0) }
        
        let updatedAtString = json["updatedAt"] as? String
        let updatedAt = updatedAtString.flatMap { ISO8601DateFormatter().date(from: $0) }
        
        return Repository(
            id: id,
            name: name,
            description: description,
            url: url,
            stargazerCount: stargazerCount,
            forkCount: forkCount,
            language: language,
            languageColor: languageColor,
            updatedAt: updatedAt,
            owner: Repository.Owner(
                login: ownerLogin,
                avatarURL: ownerAvatarURL
            )
        )
    }
}
