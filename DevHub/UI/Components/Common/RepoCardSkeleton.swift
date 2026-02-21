//
//  RepoCardSkeleton.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

// MARK: - Repo Card Skeleton

struct RepoCardSkeleton: View {
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                // Avatar + Name
                HStack(spacing: AppTheme.Spacing.small) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .shimmer()
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 14)
                            .shimmer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 80, height: 10)
                            .shimmer()
                    }
                    
                    Spacer()
                }
                
                // Description
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)
                        .shimmer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)
                        .shimmer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 180, height: 12)
                        .shimmer()
                }
                
                // Stats
                HStack(spacing: AppTheme.Spacing.medium) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 10)
                            .shimmer()
                    }
                }
            }
            .padding(AppTheme.Spacing.medium)
        }
    }
}

// MARK: - Profile Skeleton

struct ProfileSkeleton: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // Avatar
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 100)
                .shimmer()
            
            // Name
            VStack(spacing: AppTheme.Spacing.xxxSmall) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 24)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 14)
                    .shimmer()
            }
            
            // Bio
            VStack(spacing: AppTheme.Spacing.xxxSmall) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 12)
                    .shimmer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 12)
                    .shimmer()
            }
            .padding(.horizontal, AppTheme.Spacing.xxLarge)
            
            // Stats
            HStack(spacing: AppTheme.Spacing.large) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: AppTheme.Spacing.xxxSmall) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 20)
                            .shimmer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 10)
                            .shimmer()
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.large)
    }
}

// MARK: - List Skeleton

struct ListSkeleton: View {
    let count: Int
    
    init(count: Int = 5) {
        self.count = count
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            ForEach(0..<count, id: \.self) { _ in
                RepoCardSkeleton()
            }
        }
    }
}

// MARK: - Simple Skeleton Shapes

struct SkeletonText: View {
    let width: CGFloat?
    let height: CGFloat
    
    init(width: CGFloat? = nil, height: CGFloat = 14) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.3))
            .frame(width: width, height: height)
            .shimmer()
    }
}

struct SkeletonCircle: View {
    let size: CGFloat
    
    init(size: CGFloat = 40) {
        self.size = size
    }
    
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: size, height: size)
            .shimmer()
    }
}

struct SkeletonRectangle: View {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(
        width: CGFloat? = nil,
        height: CGFloat,
        cornerRadius: CGFloat = AppTheme.CornerRadius.small
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.3))
            .frame(width: width, height: height)
            .shimmer()
    }
}

// MARK: - Preview

#Preview("Repo Card Skeleton") {
    VStack(spacing: AppTheme.Spacing.medium) {
        RepoCardSkeleton()
        RepoCardSkeleton()
    }
    .padding()
}

#Preview("Profile Skeleton") {
    ProfileSkeleton()
        .background(AppTheme.Colors.background)
}

#Preview("List Skeleton") {
    ScrollView {
        ListSkeleton(count: 3)
            .padding()
    }
    .background(AppTheme.Colors.background)
}

#Preview("Skeleton Shapes") {
    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
        HStack {
            SkeletonCircle(size: 50)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                SkeletonText(width: 120)
                SkeletonText(width: 80, height: 10)
            }
        }
        
        SkeletonRectangle(height: 200)
        
        VStack(spacing: AppTheme.Spacing.xxxSmall) {
            SkeletonText()
            SkeletonText()
            SkeletonText(width: 200)
        }
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: AppTheme.Spacing.large) {
        RepoCardSkeleton()
        RepoCardSkeleton()
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
