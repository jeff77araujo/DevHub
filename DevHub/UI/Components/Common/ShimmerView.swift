//
//  ShimmerView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [
                    Color.gray.opacity(0.3),
                    Color.gray.opacity(0.5),
                    Color.gray.opacity(0.3)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.6),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: phase)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.2)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = geometry.size.width * 2
                }
            }
        }
    }
}

// MARK: - View Extension

extension View {
    func shimmer() -> some View {
        self.overlay(ShimmerView())
    }
}

// MARK: - Preview

#Preview("Shimmer Básico") {
    VStack(spacing: AppTheme.Spacing.medium) {
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 20)
            .shimmer()
        
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 20)
            .shimmer()
        
        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 200, height: 20)
            .shimmer()
    }
    .padding()
}

#Preview("Shimmer em Card") {
    GlassCard {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .shimmer()
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 16)
                        .shimmer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 12)
                        .shimmer()
                }
            }
            
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
                    .frame(width: 200, height: 12)
                    .shimmer()
            }
        }
        .padding(AppTheme.Spacing.medium)
    }
    .padding()
}
