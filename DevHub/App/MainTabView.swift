//
//  MainTabView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ReposListView()
                .tabItem {
                    Label("Repos", systemImage: "folder.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.circle.fill")
                }
        }
        .tint(AppTheme.Colors.primary)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    MainTabView()
        .environmentObject(AuthService.mock(authenticated: true))
}

#Preview("Dark Mode") {
    MainTabView()
        .environmentObject(AuthService.mock(authenticated: true))
        .preferredColorScheme(.dark)
}

#Preview("Com Dados Mockados") {
    MockedTabView()
}

// MARK: - Helper para Preview com Dados
private struct MockedTabView: View {
    @StateObject private var reposVM: ReposViewModel
    @StateObject private var profileVM: ProfileViewModel
    
    init() {
        let repos = ReposViewModel(reposService: MockGitHubReposService())
        repos.repositories = Repository.mocks
        _reposVM = StateObject(wrappedValue: repos)
        
        let profile = ProfileViewModel(
            userRepository: MockUserRepository(state: .success),
            initialUser: User.mock
        )
        _profileVM = StateObject(wrappedValue: profile)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            // ReposListView customizado
            NavigationStack {
                ZStack {
                    AppTheme.Colors.background.ignoresSafeArea()
                    
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.medium) {
                            ForEach(reposVM.repositories) { repo in
                                RepoCard(
                                    repository: repo,
                                    onTap: { print("Tapped: \(repo.name)") },
                                    onFavorite: {
                                        print("Favorited: \(repo.name)")
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Trending")
                .navigationBarTitleDisplayMode(.large)
            }
            .tabItem { Label("Repos", systemImage: "folder.fill") }
            
            // ProfileView customizado
            NavigationStack {
                ZStack {
                    AppTheme.Colors.background.ignoresSafeArea()
                    if let user = profileVM.user {
                        ProfileContent(user: user, onLogout: {})
                    }
                }
                .navigationTitle("Perfil")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Perfil", systemImage: "person.circle.fill") }
        }
        .environmentObject(AuthService.mock(authenticated: true))
        .tint(AppTheme.Colors.primary)
    }
}
