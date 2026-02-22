//
//  ProfileView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProfileSkeleton()
                } else if let user = viewModel.user {
                    ProfileContent(
                        user: user,
                        onLogout: { authService.logout() }
                    )
                } else if let error = viewModel.errorMessage {
                    EmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Erro ao carregar",
                        message: error,
                        action: (
                            title: "Tentar Novamente",
                            icon: "arrow.clockwise",
                            color: nil,
                            action: { Task { await viewModel.loadProfile() } }
                        )
                    )
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { authService.logout() }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                }
            }
            .task {
                await viewModel.loadProfile()
            }
        }
    }
}

// MARK: - Previews
#Preview("Erro") {
    NavigationStack {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            EmptyState(
                icon: "exclamationmark.triangle",
                title: "Erro ao carregar",
                message: "Não foi possível carregar o perfil",
                action: (
                    title: "Tentar Novamente",
                    icon: "arrow.clockwise",
                    color: nil,
                    action: {}
                )
            )
        }
        .navigationTitle("Perfil")
    }
    .withAuth()
}

#Preview("Sucesso - Light Mode") {
    NavigationStack {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            ProfileContent(user: User.mock, onLogout: {})
        }
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.inline)
    }
    .withAuth()
}

#Preview("Sucesso - Dark Mode") {
    NavigationStack {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            ProfileContent(user: User.mock, onLogout: {})
        }
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.inline)
    }
    .withAuth()
    .preferredColorScheme(.dark)
}
