//
//  FavoriteRepository.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import Foundation
import SwiftData

@Model
final class FavoriteRepository {
    @Attribute(.unique) var id: String
    var name: String
    var repoDescription: String?
    var url: String
    var stargazerCount: Int
    var forkCount: Int
    var language: String?
    var languageColor: String?
    var ownerLogin: String
    var ownerAvatarURL: String?
    var favoritedAt: Date
    
    init(
        id: String,
        name: String,
        repoDescription: String?,
        url: String,
        stargazerCount: Int,
        forkCount: Int,
        language: String?,
        languageColor: String?,
        ownerLogin: String,
        ownerAvatarURL: String?,
        favoritedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.repoDescription = repoDescription
        self.url = url
        self.stargazerCount = stargazerCount
        self.forkCount = forkCount
        self.language = language
        self.languageColor = languageColor
        self.ownerLogin = ownerLogin
        self.ownerAvatarURL = ownerAvatarURL
        self.favoritedAt = favoritedAt
    }
    
    // MARK: - Converter para Repository
    func toRepository() -> Repository? {
        guard let validURL = URL(string: url) else {
            print("⚠️ URL inválida: \(url)")
            return nil
        }
        
        return Repository(
            id: id,
            name: name,
            description: repoDescription,
            url: validURL,
            stargazerCount: stargazerCount,
            forkCount: forkCount,
            language: language,
            languageColor: languageColor,
            updatedAt: favoritedAt,
            owner: Repository.Owner(
                login: ownerLogin,
                avatarURL: ownerAvatarURL.flatMap { URL(string: $0) }
            ),
            isFavorite: true
        )
    }
}

// MARK: - Repository Extension
extension Repository {
    func toFavorite() -> FavoriteRepository {
        FavoriteRepository(
            id: id,
            name: name,
            repoDescription: description,
            url: url.absoluteString,
            stargazerCount: stargazerCount,
            forkCount: forkCount,
            language: language,
            languageColor: languageColor,
            ownerLogin: owner.login,
            ownerAvatarURL: owner.avatarURL?.absoluteString
        )
    }
}
