//
//  ButtonGroup.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

// MARK: - Button Action Type

typealias ButtonAction = (title: String, icon: String?, color: Color?, action: () -> Void)

// MARK: - Private Button Components

private struct PrimaryButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            hapticFeedback()
            action()
        }) {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(AppTheme.Typography.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.small)
            .background(color)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

private struct SecondaryButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            hapticFeedback()
            action()
        }) {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(AppTheme.Typography.headline)
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.small)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(color, lineWidth: 2)
            )
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

private struct TextButton: View {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            hapticFeedback()
            action()
        }) {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(AppTheme.Typography.callout)
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.small)
        }
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: - Public ButtonGroup Component

struct ButtonGroup: View {
    let primaryAction: ButtonAction
    let secondaryAction: ButtonAction?
    let tertiaryAction: ButtonAction?
    
    init(
        primaryAction: ButtonAction,
        secondaryAction: ButtonAction? = nil,
        tertiaryAction: ButtonAction? = nil
    ) {
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.tertiaryAction = tertiaryAction
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            // Primary Button (preenchido)
            PrimaryButton(
                title: primaryAction.title,
                icon: primaryAction.icon,
                color: primaryAction.color ?? AppTheme.Colors.primary,
                action: primaryAction.action
            )
            
            // Secondary Button (outlined) - opcional
            if let secondary = secondaryAction {
                SecondaryButton(
                    title: secondary.title,
                    icon: secondary.icon,
                    color: secondary.color ?? AppTheme.Colors.primary,
                    action: secondary.action
                )
            }
            
            // Tertiary Button (texto apenas) - opcional
            if let tertiary = tertiaryAction {
                TextButton(
                    title: tertiary.title,
                    icon: tertiary.icon,
                    color: tertiary.color ?? AppTheme.Colors.primary,
                    action: tertiary.action
                )
            }
        }
    }
}

// MARK: - Preview

#Preview("1 Botão") {
    VStack {
        ButtonGroup(
            primaryAction: (
                title: "Login",
                icon: "arrow.right.circle.fill",
                color: nil,
                action: { print("Login") }
            )
        )
        .padding()
    }
}

#Preview("2 Botões") {
    VStack {
        ButtonGroup(
            primaryAction: (
                title: "Confirmar",
                icon: "checkmark.circle.fill",
                color: .blue,
                action: { print("Confirmar") }
            ),
            secondaryAction: (
                title: "Cancelar",
                icon: "xmark.circle",
                color: .red,
                action: { print("Cancelar") }
            )
        )
        .padding()
    }
}

#Preview("3 Botões") {
    VStack {
        ButtonGroup(
            primaryAction: (
                title: "Salvar",
                icon: "checkmark.circle.fill",
                color: .green,
                action: { print("Salvar") }
            ),
            secondaryAction: (
                title: "Ver Detalhes",
                icon: "info.circle",
                color: .blue,
                action: { print("Detalhes") }
            ),
            tertiaryAction: (
                title: "Descartar",
                icon: nil,
                color: .gray,
                action: { print("Descartar") }
            )
        )
        .padding()
    }
}

#Preview("Dark Mode") {
    VStack {
        ButtonGroup(
            primaryAction: (
                title: "Login",
                icon: "arrow.right.circle.fill",
                color: nil,
                action: { print("Login") }
            ),
            secondaryAction: (
                title: "Criar Conta",
                icon: "person.badge.plus",
                color: nil,
                action: { print("Criar") }
            ),
            tertiaryAction: (
                title: "Esqueci a senha",
                icon: nil,
                color: nil,
                action: { print("Esqueci") }
            )
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
