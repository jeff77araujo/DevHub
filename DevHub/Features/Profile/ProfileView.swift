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
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            profileHeader(user: user)
                            statsSection(user: user)
                            infoSection(user: user)
                        }
                        .padding()
                    }
                } else if let error = viewModel.errorMessage {
                    EmptyState(
                        icon: "exclamationmark.triangle",
                        title: "Erro ao carregar",
                        message: error,
                        action: (
                            title: "Tentar Novamente",
                            icon: "arrow.clockwise",
                            color: nil,
                            action: {
                                Task { await viewModel.loadProfile() }
                            }
                        )
                    )
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        authService.logout()
                    }) {
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
    
    // MARK: - Profile Header
    @ViewBuilder
    private func profileHeader(user: User) -> some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            // Avatar
            AsyncImage(url: user.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(AppTheme.Colors.System.tertiaryLabel)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(AppTheme.Colors.primary, lineWidth: 3)
            )
            
            // Name & Login
            VStack(spacing: AppTheme.Spacing.xxxSmall) {
                if let name = user.name {
                    Text(name)
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.System.label)
                }
                
                Text("@\(user.login)")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
            }
            
            // Bio
            if let bio = user.bio {
                Text(bio)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.large)
            }
        }
    }
    
    // MARK: - Stats Section
    @ViewBuilder
    private func statsSection(user: User) -> some View {
        GlassCard {
            HStack(spacing: 0) {
                statItem(
                    title: "Repositórios",
                    count: user.repositoriesCount
                )
                
                Divider()
                    .frame(height: 40)
                
                statItem(
                    title: "Seguidores",
                    count: user.followersCount
                )
                
                Divider()
                    .frame(height: 40)
                
                statItem(
                    title: "Seguindo",
                    count: user.followingCount
                )
            }
            .padding(.vertical, AppTheme.Spacing.medium)
        }
    }
    
    @ViewBuilder
    private func statItem(title: String, count: Int) -> some View {
        VStack(spacing: AppTheme.Spacing.xxxSmall) {
            Text("\(count)")
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.primary)
            
            Text(title)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.System.secondaryLabel)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Info Section
    @ViewBuilder
    private func infoSection(user: User) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                SectionTitle("Informações")
                
                Divider()
                
                VStack(spacing: AppTheme.Spacing.small) {
                    if let company = user.company {
                        infoRow(icon: "building.2", text: company)
                    }
                    
                    if let location = user.location {
                        infoRow(icon: "location", text: location)
                    }
                    
                    if let email = user.email {
                        infoRow(icon: "envelope", text: email)
                    }
                    
                    if let twitter = user.twitterUsername {
                        infoRow(icon: "bird", text: "@\(twitter)")
                    }
                }
            }
            .padding(AppTheme.Spacing.medium)
        }
    }
    
    @ViewBuilder
    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                .frame(width: 20)
            
            Text(text)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.System.label)
        }
    }
}

#Preview("Loading") {
    ProfileView()
        .environmentObject(AuthService())
}
