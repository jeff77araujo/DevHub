//
//  MockUserRepository.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

// Core/Repositories/MockUserRepository.swift
import Foundation

final class MockUserRepository: UserRepositoryProtocol {
    enum MockState {
        case success
        case error
    }
    
    let state: MockState
    
    init(state: MockState = .success, delay: TimeInterval = 0) {
        self.state = state
    }
    
    func fetchCurrentUser() async throws -> User {
        if state == .error {
            throw RepositoryError.invalidResponse
        }
        return User.mock
    }
}
