//
//  User.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let login: String
    let name: String?
    let avatarURL: URL?
    let bio: String?
    let company: String?
    let location: String?
    let email: String?
    let websiteURL: URL?
    let twitterUsername: String?
    let followersCount: Int
    let followingCount: Int
    let repositoriesCount: Int
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, login, name, bio, company, location, email
        case avatarURL = "avatar_url"
        case websiteURL = "website_url"
        case twitterUsername = "twitter_username"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case repositoriesCount = "repositories_count"
        case createdAt = "created_at"
    }
}

// MARK: - Mock for Preview
extension User {
    static let mock = User(
        id: "1",
        login: "octocat",
        name: "The Octocat",
        avatarURL: URL(string: "https://avatars.githubusercontent.com/u/583231?v=4"),
        bio: "GitHub's mascot and logo",
        company: "@github",
        location: "San Francisco",
        email: "octocat@github.com",
        websiteURL: URL(string: "https://github.com/octocat"),
        twitterUsername: "github",
        followersCount: 5000,
        followingCount: 10,
        repositoriesCount: 8,
        createdAt: Date()
    )
}
