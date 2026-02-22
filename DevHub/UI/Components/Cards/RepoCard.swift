//
//  RepoCard.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import SwiftUI

struct RepoCard: View {
    let repository: Repository
    let onTap: () -> Void
    let onFavorite: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            GlassCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    // Header (Owner)
                    HStack(spacing: AppTheme.Spacing.small) {
                        AsyncImage(url: repository.owner.avatarURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(AppTheme.Colors.System.tertiaryLabel)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        
                        Text(repository.owner.login)
                            .font(AppTheme.Typography.callout)
                            .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                        
                        Spacer()
                        
                        // Favorite Button
                        Button(action: onFavorite) {
                            Image(systemName: repository.isFavorite ? "star.fill" : "star")
                                .foregroundColor(repository.isFavorite ? .yellow : AppTheme.Colors.System.tertiaryLabel)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Repo Name
                    Text(repository.name)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.System.label)
                        .lineLimit(1)
                    
                    // Description
                    if let description = repository.description {
                        Text(description)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                            .lineLimit(2)
                    }
                    
                    // Stats
                    HStack(spacing: AppTheme.Spacing.medium) {
                        // Language
                        if let language = repository.language {
                            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                                Circle()
                                    .fill(Color(hex: repository.languageColor ?? "#cccccc"))
                                    .frame(width: 12, height: 12)
                                
                                Text(language)
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                            }
                        }
                        
                        // Stars
                        HStack(spacing: AppTheme.Spacing.xxxSmall) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            
                            Text("\(repository.stargazerCount.formatted())")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                        }
                        
                        // Forks
                        HStack(spacing: AppTheme.Spacing.xxxSmall) {
                            Image(systemName: "tuningfork")
                                .font(.caption)
                                .foregroundColor(AppTheme.Colors.System.tertiaryLabel)
                            
                            Text("\(repository.forkCount.formatted())")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                        }
                        
                        Spacer()
                    }
                }
                .padding(AppTheme.Spacing.medium)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Color Extension (Helper)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#Preview("Repo Card") {
    VStack(spacing: AppTheme.Spacing.medium) {
        RepoCard(
            repository: Repository.mock,
            onTap: { print("Tapped") },
            onFavorite: { print("Favorited") }
        )
        
        RepoCard(
            repository: Repository.mocks[1],
            onTap: { print("Tapped") },
            onFavorite: { print("Favorited") }
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}

#Preview("Dark Mode") {
    VStack(spacing: AppTheme.Spacing.medium) {
        RepoCard(
            repository: Repository.mock,
            onTap: { print("Tapped") },
            onFavorite: { print("Favorited") }
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
