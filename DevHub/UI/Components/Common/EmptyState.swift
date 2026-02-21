//
//  EmptyState.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct EmptyState: View {
    let icon: String
    let title: String
    let message: String
    let action: ButtonAction?
    
    init(
        icon: String,
        title: String,
        message: String,
        action: ButtonAction? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.medium) {
                // Ícone
                Image(systemName: icon)
                    .font(.system(size: 70))
                    .foregroundColor(AppTheme.Colors.System.tertiaryLabel)
                
                // Título
                Text(title)
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.Colors.System.label)
                    .multilineTextAlignment(.center)
                
                // Mensagem
                Text(message)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.large)
            }
            
            // Botão de ação (opcional)
            if let action = action {
                ButtonGroup(
                    primaryAction: action
                )
                .padding(.horizontal, AppTheme.Spacing.xxLarge)
                .padding(.top, AppTheme.Spacing.medium)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview("Sem Ação") {
    EmptyState(
        icon: "tray",
        title: "Nenhum repositório",
        message: "Você ainda não favoritou nenhum repositório. Explore e adicione seus favoritos!"
    )
}

#Preview("Com Ação") {
    EmptyState(
        icon: "network.slash",
        title: "Sem conexão",
        message: "Não foi possível conectar ao servidor. Verifique sua internet e tente novamente.",
        action: (
            title: "Tentar Novamente",
            icon: "arrow.clockwise",
            color: nil,
            action: { print("Retry") }
        )
    )
}

#Preview("Busca Vazia") {
    EmptyState(
        icon: "magnifyingglass",
        title: "Nenhum resultado",
        message: "Não encontramos nenhum repositório com esses termos. Tente outra busca.",
        action: (
            title: "Limpar Busca",
            icon: "xmark.circle",
            color: AppTheme.Colors.secondary,
            action: { print("Clear") }
        )
    )
}

#Preview("Favoritos Vazios") {
    EmptyState(
        icon: "star",
        title: "Sem favoritos ainda",
        message: "Comece explorando repositórios trending e marque seus favoritos para acessá-los rapidamente.",
        action: (
            title: "Explorar Trending",
            icon: "flame.fill",
            color: .orange,
            action: { print("Explore") }
        )
    )
}

#Preview("Dark Mode") {
    EmptyState(
        icon: "exclamationmark.triangle",
        title: "Erro ao carregar",
        message: "Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.",
        action: (
            title: "Recarregar",
            icon: "arrow.clockwise",
            color: nil,
            action: { print("Reload") }
        )
    )
    .background(AppTheme.Colors.background)
    .preferredColorScheme(.dark)
}
