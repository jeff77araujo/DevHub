//
//  GlassCard.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let elevation: AppTheme.Elevation.Shadow
    
    init(
        cornerRadius: CGFloat = AppTheme.CornerRadius.medium,
        elevation: AppTheme.Elevation.Shadow = AppTheme.Elevation.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.elevation = elevation
        self.content = content()
    }
    
    var body: some View {
        content
            .background(AppTheme.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .elevation(elevation)
    }
}

// MARK: - Preview

#Preview("Card Básico") {
    VStack {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Título do Card")
                    .font(AppTheme.Typography.headline)
                
                Text("Este é um card de exemplo usando o componente GlassCard reutilizável.")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
            }
            .padding(AppTheme.Spacing.medium)
        }
        .padding()
    }
}

#Preview("Card com Elevação Alta") {
    VStack {
        GlassCard(elevation: AppTheme.Elevation.high) {
            VStack(spacing: AppTheme.Spacing.medium) {
                Image(systemName: "star.fill")
                    .font(.system(size: 50))
                    .foregroundColor(AppTheme.Colors.primary)
                
                Text("Card Destacado")
                    .font(AppTheme.Typography.title2)
                
                Text("Com sombra mais pronunciada")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
            }
            .padding(AppTheme.Spacing.large)
        }
        .padding()
    }
}

#Preview("Card Arredondado") {
    VStack {
        GlassCard(cornerRadius: AppTheme.CornerRadius.xLarge) {
            HStack(spacing: AppTheme.Spacing.medium) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.Colors.primary)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    Text("Jeff Araujo")
                        .font(AppTheme.Typography.headline)
                    
                    Text("Desenvolvedor iOS")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                }
                
                Spacer()
            }
            .padding(AppTheme.Spacing.medium)
        }
        .padding()
    }
}

#Preview("Dark Mode") {
    VStack(spacing: AppTheme.Spacing.large) {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Card em Dark Mode")
                    .font(AppTheme.Typography.headline)
                
                Text("As cores se adaptam automaticamente")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
            }
            .padding(AppTheme.Spacing.medium)
        }
        
        GlassCard(elevation: AppTheme.Elevation.high) {
            Text("Card com elevação alta")
                .font(AppTheme.Typography.title3)
                .padding(AppTheme.Spacing.large)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
