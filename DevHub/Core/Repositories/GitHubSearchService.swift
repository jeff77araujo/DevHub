//
//  GitHubSearchService.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/03/26.
//

//
//  GitHubSearchService.swift
//  DevHub
//
//  Sprint 4.2: Busca de Repositórios
//

import Foundation

// MARK: - Search Response Models

struct SearchRepositoriesResponse: Codable {
    let data: SearchData
}

struct SearchData: Codable {
    let search: SearchResult
}

struct SearchResult: Codable {
    let repositoryCount: Int
    let edges: [SearchEdge]
}

struct SearchEdge: Codable {
    let node: SearchNode
}

struct SearchNode: Codable {
    let id: String
    let name: String
    let description: String?
    let stargazerCount: Int
    let forkCount: Int
    let primaryLanguage: SearchLanguage?
    let owner: SearchOwner
    let updatedAt: String
    let url: String
}

struct SearchLanguage: Codable {
    let name: String
    let color: String?
}

struct SearchOwner: Codable {
    let login: String
    let avatarUrl: String
}

// MARK: - GitHub Search Service

@MainActor
class GitHubSearchService {
    
    // MARK: - Search Method
    
    func searchRepositories(
        query: String,
        language: String? = nil,
        minStars: Int? = nil,
        orderBy: SearchOrder = .bestMatch
    ) async throws -> [Repository] {
        
        // Construir query de busca
        var searchQuery = query
        
        if let language = language, !language.isEmpty {
            searchQuery += " language:\(language)"
        }
        
        if let minStars = minStars {
            searchQuery += " stars:>=\(minStars)"
        }
        
        // Debug
        print("🔍 Buscando: \(searchQuery)")
        
        // GraphQL Query
        let graphQLQuery = """
        query SearchRepositories($searchQuery: String!) {
          search(query: $searchQuery, type: REPOSITORY, first: 30) {
            repositoryCount
            edges {
              node {
                ... on Repository {
                  id
                  name
                  description
                  stargazerCount
                  forkCount
                  primaryLanguage {
                    name
                    color
                  }
                  owner {
                    login
                    avatarUrl
                  }
                  updatedAt
                  url
                }
              }
            }
          }
        }
        """
        
        let variables: [String: Any] = [
            "searchQuery": searchQuery
        ]
        
        let body: [String: Any] = [
            "query": graphQLQuery,
            "variables": variables
        ]
        
        // Request
        let url = URL(string: "https://api.github.com/graphql")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Token from Keychain
        guard let token = KeychainManager.shared.githubToken else {
            throw ServiceError.unauthorized
        }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Erro ao serializar JSON: \(error)")
            throw ServiceError.invalidRequest
        }
        
        // Execute request
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug da resposta
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status code: \(httpResponse.statusCode)")
            }
            
            // Debug do JSON bruto
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 JSON bruto: \(jsonString.prefix(500))...")
            }
            
            // Verificar se houve erro na resposta
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errors = json["errors"] as? [[String: Any]] {
                let errorMessages = errors.compactMap { $0["message"] as? String }.joined(separator: ", ")
                print("❌ Erro GraphQL: \(errorMessages)")
                throw ServiceError.networkError(errorMessages)
            }
            
            // Decodificar resposta
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(SearchRepositoriesResponse.self, from: data)
            
            // Converter para Repository
            let repositories = searchResponse.data.search.edges.map { edge in
                Repository(
                    id: edge.node.id,
                    name: edge.node.name,
                    description: edge.node.description,
                    url: URL(string: edge.node.url) ?? URL(string: "https://github.com")!,
                    stargazerCount: edge.node.stargazerCount,
                    forkCount: edge.node.forkCount,
                    language: edge.node.primaryLanguage?.name,
                    languageColor: edge.node.primaryLanguage?.color,
                    updatedAt: ISO8601DateFormatter().date(from: edge.node.updatedAt),
                    owner: Repository.Owner(
                        login: edge.node.owner.login,
                        avatarURL: URL(string: edge.node.owner.avatarUrl)
                    )
                )
            }
            
            // Aplicar ordenação se necessário
            switch orderBy {
            case .stars:
                return repositories.sorted { $0.stargazerCount > $1.stargazerCount }
            case .updated:
                return repositories.sorted { 
                    ($0.updatedAt ?? Date.distantPast) > ($1.updatedAt ?? Date.distantPast) 
                }
            case .bestMatch:
                return repositories
            }
            
        } catch let decodingError as DecodingError {
            print("❌ Erro de decodificação: \(decodingError)")
            
            // Debug detalhado
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("  - Chave não encontrada: \(key.stringValue)")
                print("  - Contexto: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("  - Tipo errado: esperava \(type)")
                print("  - Contexto: \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("  - Valor não encontrado para tipo: \(type)")
                print("  - Contexto: \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("  - Dados corrompidos")
                print("  - Contexto: \(context.debugDescription)")
            @unknown default:
                print("  - Erro desconhecido")
            }
            
            throw ServiceError.decodingError
        } catch {
            print("❌ Erro na busca: \(error)")
            throw ServiceError.networkError(error.localizedDescription)
        }
    }
}

// MARK: - Search Order

enum SearchOrder: String, CaseIterable {
    case bestMatch = "Melhor correspondência"
    case stars = "Mais estrelas"
    case updated = "Atualizados recentemente"
}

// MARK: - Service Error

enum ServiceError: LocalizedError {
    case unauthorized
    case invalidRequest
    case decodingError
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Não autorizado. Faça login novamente."
        case .invalidRequest:
            return "Requisição inválida."
        case .decodingError:
            return "Erro ao processar resposta do servidor."
        case .networkError(let message):
            return "Erro de rede: \(message)"
        }
    }
}
