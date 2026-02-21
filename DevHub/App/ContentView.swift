//
//  ContentView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.large) {
                // Logo/Título
                VStack(spacing: AppTheme.Spacing.small) {
                    Text("DevHub")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    Text("Explore GitHub Repositories")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                }
                
                // Card de Boas-vindas
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    Text("Bem-vindo!")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.System.label)
                    
                    Text("Descubra repositórios trending, siga desenvolvedores e fique por dentro do mundo open source.")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                    
                    // Botão de exemplo
                    Button(action: {
                        print("Login tapped")
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Começar")
                        }
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(AppTheme.Spacing.small)
                        .background(AppTheme.Colors.primary)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                }
                .padding(AppTheme.Spacing.large)
                .cardStyle()
                .padding(.horizontal, AppTheme.Spacing.large)
                
                Spacer()
            }
            .padding(.top, AppTheme.Spacing.xxLarge)
        }
    }
}

#Preview {
    ContentView()
}
