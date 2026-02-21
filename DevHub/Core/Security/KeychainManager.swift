//
//  KeychainManager.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import Foundation
import KeychainSwift

final class KeychainManager {
    static let shared = KeychainManager()
    
    private let keychain = KeychainSwift()
    
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let githubToken = "github_token"
    }
    
    // MARK: - GitHub Token
    var githubToken: String? {
        get { keychain.get(Keys.githubToken) }
        set {
            if let value = newValue {
                keychain.set(value, forKey: Keys.githubToken)
            } else {
                keychain.delete(Keys.githubToken)
            }
        }
    }
    
    // MARK: - Clear All
    func clearAll() {
        keychain.clear()
    }
}
