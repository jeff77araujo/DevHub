//
//  ProfileViewModel.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import Foundation
internal import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }
    
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await userRepository.fetchCurrentUser()
            self.user = user
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
