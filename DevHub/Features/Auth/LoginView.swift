//
//  LoginView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authService = AuthService()
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xxLarge) {
                Spacer()
                
                // Logo e Título
                VStack(spacing: AppTheme.Spacing.medium) {
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    Text("DevHub")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.System.label)
                    
                    Text("Explore o mundo open source")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                }
                
                Spacer()
                
                // Card com botão de login
                GlassCard {
                    VStack(spacing: AppTheme.Spacing.large) {
                        VStack(spacing: AppTheme.Spacing.small) {
                            SectionTitle(
                                "Bem-vindo!",
                                subtitle: "Conecte-se com sua conta GitHub"
                            )
                            
                            Text("Acesse repositórios trending, siga desenvolvedores e descubra projetos incríveis.")
                                .font(AppTheme.Typography.callout)
                                .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                                .multilineTextAlignment(.center)
                        }
                        
                        if authService.isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            ButtonGroup(
                                primaryAction: (
                                    title: "Login com GitHub",
                                    icon: "arrow.right.circle.fill",
                                    color: AppTheme.Colors.primary,
                                    action: {
                                        authService.startOAuthFlow()
                                    }
                                )
                            )
                        }
                        
                        // Error message
                        if let error = authService.errorMessage {
                            Text(error)
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(AppTheme.Spacing.large)
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                
                // Footer
                VStack(spacing: AppTheme.Spacing.xxxSmall) {
                    Text("Ao continuar, você concorda com nossos")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.System.tertiaryLabel)
                    
                    HStack(spacing: AppTheme.Spacing.xxxSmall) {
                        Button("Termos de Uso") {
                            print("Termos")
                        }
                        .font(AppTheme.Typography.caption)
                        
                        Text("e")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.System.tertiaryLabel)
                        
                        Button("Política de Privacidade") {
                            print("Privacidade")
                        }
                        .font(AppTheme.Typography.caption)
                    }
                }
                .padding(.bottom, AppTheme.Spacing.large)
            }
        }
    }
}

#Preview {
    LoginView()
}

#Preview("Dark Mode") {
    LoginView()
        .preferredColorScheme(.dark)
}
