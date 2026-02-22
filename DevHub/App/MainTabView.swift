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
    let reposVM = ReposViewModel(reposService: MockGitHubReposService())
    reposVM.repositories = Repository.mocks
    
    let profileVM = ProfileViewModel(
        userRepository: MockUserRepository(state: .success),
        initialUser: User.mock
    )
    
    return TabView {
        HomeView()
            .tabItem { Label("Home", systemImage: "house.fill") }
        
        // ReposListView customizado com dados mockados
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.medium) {
                        ForEach(reposVM.repositories) { repo in
                            RepoCard(
                                repository: repo,
                                onTap: { print("Tapped: \(repo.name)") },
                                onFavorite: { reposVM.toggleFavorite(repository: repo) }
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
        
        // ProfileView customizado com dados mockados
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
