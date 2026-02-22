//
//  UserRepository.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func fetchCurrentUser() async throws -> User
}

final class UserRepository: UserRepositoryProtocol {
    private let keychainManager = KeychainManager.shared
    
    func fetchCurrentUser() async throws -> User {
        guard let token = keychainManager.githubToken else {
            throw RepositoryError.notAuthenticated
        }
        
        let query = """
        query {
          viewer {
            id
            login
            name
            avatarUrl
            bio
            company
            location
            email
            websiteUrl
            twitterUsername
            followers {
              totalCount
            }
            following {
              totalCount
            }
            repositories {
              totalCount
            }
            createdAt
          }
        }
        """
        
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
        guard let dataObj = json?["data"] as? [String: Any],
              let viewer = dataObj["viewer"] as? [String: Any] else {
            throw RepositoryError.invalidResponse
        }
        
        return try parseUser(from: viewer)
    }
    
    private func parseUser(from json: [String: Any]) throws -> User {
        let id = json["id"] as? String ?? ""
        let login = json["login"] as? String ?? ""
        let name = json["name"] as? String
        let avatarURLString = json["avatarUrl"] as? String
        let bio = json["bio"] as? String
        let company = json["company"] as? String
        let location = json["location"] as? String
        let email = json["email"] as? String
        let websiteURLString = json["websiteUrl"] as? String
        let twitterUsername = json["twitterUsername"] as? String
        
        let followers = (json["followers"] as? [String: Any])?["totalCount"] as? Int ?? 0
        let following = (json["following"] as? [String: Any])?["totalCount"] as? Int ?? 0
        let repositories = (json["repositories"] as? [String: Any])?["totalCount"] as? Int ?? 0
        
        let createdAtString = json["createdAt"] as? String
        let createdAt = createdAtString.flatMap { ISO8601DateFormatter().date(from: $0) }
        
        return User(
            id: id,
            login: login,
            name: name,
            avatarURL: avatarURLString.flatMap { URL(string: $0) },
            bio: bio,
            company: company,
            location: location,
            email: email,
            websiteURL: websiteURLString.flatMap { URL(string: $0) },
            twitterUsername: twitterUsername,
            followersCount: followers,
            followingCount: following,
            repositoriesCount: repositories,
            createdAt: createdAt
        )
    }
}

enum RepositoryError: LocalizedError {
    case notAuthenticated
    case invalidResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Usuário não autenticado"
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        }
    }
}
