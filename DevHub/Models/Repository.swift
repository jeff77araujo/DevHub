//
//  Repository.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import Foundation

struct Repository: Identifiable, Codable {
    let id: String
    let name: String
    let description: String?
    let url: URL
    let stargazerCount: Int
    let forkCount: Int
    let language: String?
    let languageColor: String?
    let updatedAt: Date?
    let owner: Owner
    var isFavorite: Bool = false
    
    struct Owner: Codable {
        let login: String
        let avatarURL: URL?
        
        enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, url, language, owner
        case stargazerCount = "stargazer_count"
        case forkCount = "fork_count"
        case languageColor = "language_color"
        case updatedAt = "updated_at"
        case isFavorite = "is_favorite"
    }
}

// MARK: - Mock for Preview
extension Repository {
    static let mock = Repository(
        id: "1",
        name: "awesome-ios",
        description: "A curated list of awesome iOS ecosystem, including Objective-C and Swift Projects",
        url: URL(string: "https://github.com/vsouza/awesome-ios")!,
        stargazerCount: 45000,
        forkCount: 6800,
        language: "Swift",
        languageColor: "#F05138",
        updatedAt: Date(),
        owner: Owner(
            login: "vsouza",
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/484656?v=4")
        )
    )
    
    static let mocks: [Repository] = [
        mock,
        Repository(
            id: "2",
            name: "swift",
            description: "The Swift Programming Language",
            url: URL(string: "https://github.com/apple/swift")!,
            stargazerCount: 65000,
            forkCount: 10000,
            language: "C++",
            languageColor: "#F34B7D",
            updatedAt: Date(),
            owner: Owner(
                login: "apple",
                avatarURL: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")
            )
        ),
        Repository(
            id: "3",
            name: "Alamofire",
            description: "Elegant HTTP Networking in Swift",
            url: URL(string: "https://github.com/Alamofire/Alamofire")!,
            stargazerCount: 40000,
            forkCount: 7500,
            language: "Swift",
            languageColor: "#F05138",
            updatedAt: Date(),
            owner: Owner(
                login: "Alamofire",
                avatarURL: URL(string: "https://avatars.githubusercontent.com/u/7774181?v=4")
            )
        )
    ]
}
