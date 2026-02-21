//
//  SectionTitle.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct SectionTitle: View {
    let title: String
    let subtitle: String?
    
    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
            Text(title)
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.System.label)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview("Título Simples") {
    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
        SectionTitle("Repositórios")
        
        SectionTitle("Trending")
        
        SectionTitle("Meus Favoritos")
    }
    .padding()
}

#Preview("Título com Subtitle") {
    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
        SectionTitle(
            "Repositórios",
            subtitle: "Explore projetos incríveis"
        )
        
        SectionTitle(
            "Trending",
            subtitle: "Os mais populares hoje"
        )
        
        SectionTitle(
            "Meus Favoritos",
            subtitle: "12 repositórios salvos"
        )
    }
    .padding()
}

#Preview("Em Card") {
    GlassCard {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            SectionTitle(
                "Configurações",
                subtitle: "Personalize sua experiência"
            )
            
            Divider()
            
            Text("Conteúdo do card aqui...")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.System.secondaryLabel)
        }
        .padding(AppTheme.Spacing.medium)
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
        SectionTitle(
            "Bem-vindo ao DevHub",
            subtitle: "Explore o mundo open source"
        )
        
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                SectionTitle("Seus Repositórios", subtitle: "8 projetos ativos")
                
                Divider()
                
                Text("Lista de repositórios aqui...")
                    .font(AppTheme.Typography.caption)
            }
            .padding(AppTheme.Spacing.medium)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
