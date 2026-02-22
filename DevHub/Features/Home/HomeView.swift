//
//  HomeView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.xxLarge) {
                        // Header
                        headerSection
                        
                        // Quick Actions
                        quickActionsSection
                        
                        // Features
                        featuresSection
                        
                        Spacer(minLength: AppTheme.Spacing.xxLarge)
                    }
                    .padding()
                }
            }
            .navigationTitle("DevHub")
            .navigationBarTitleDisplayMode(.large)
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
        }
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.primary)
            
            VStack(spacing: AppTheme.Spacing.small) {
                Text("Bem-vindo ao DevHub!")
                    .font(AppTheme.Typography.title)
                    .foregroundColor(AppTheme.Colors.System.label)
                
                Text("Explore, descubra e conecte-se com o mundo open source")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(.top, AppTheme.Spacing.large)
    }
    
    // MARK: - Quick Actions
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            SectionTitle("Ações Rápidas")
            
            GlassCard {
                VStack(spacing: AppTheme.Spacing.small) {
                    quickActionButton(
                        icon: "magnifyingglass",
                        title: "Buscar Repositórios",
                        subtitle: "Encontre projetos incríveis",
                        color: .blue
                    )
                    
                    Divider()
                    
                    quickActionButton(
                        icon: "flame.fill",
                        title: "Trending Hoje",
                        subtitle: "Veja o que está em alta",
                        color: .orange
                    )
                    
                    Divider()
                    
                    quickActionButton(
                        icon: "star.fill",
                        title: "Meus Favoritos",
                        subtitle: "Acesse seus repos salvos",
                        color: .yellow
                    )
                }
                .padding(AppTheme.Spacing.medium)
            }
        }
    }
    
    @ViewBuilder
    private func quickActionButton(
        icon: String,
        title: String,
        subtitle: String,
        color: Color
    ) -> some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            HStack(spacing: AppTheme.Spacing.medium) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .cornerRadius(AppTheme.CornerRadius.medium)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    Text(title)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.System.label)
                    
                    Text(subtitle)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.Colors.System.tertiaryLabel)
            }
        }
    }
    
    // MARK: - Features Section
    @ViewBuilder
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            SectionTitle("Recursos")
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: AppTheme.Spacing.medium
            ) {
                featureCard(
                    icon: "person.2.fill",
                    title: "Desenvolvedores",
                    description: "Siga e conecte-se",
                    color: .purple
                )
                
                featureCard(
                    icon: "folder.fill",
                    title: "Repositórios",
                    description: "Explore projetos",
                    color: .green
                )
                
                featureCard(
                    icon: "bell.fill",
                    title: "Notificações",
                    description: "Fique atualizado",
                    color: .red
                )
                
                featureCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Estatísticas",
                    description: "Acompanhe métricas",
                    color: .cyan
                )
            }
        }
    }
    
    @ViewBuilder
    private func featureCard(
        icon: String,
        title: String,
        description: String,
        color: Color
    ) -> some View {
        GlassCard {
            VStack(spacing: AppTheme.Spacing.small) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.System.label)
                
                Text(description)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.System.secondaryLabel)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.medium)
        }
    }
}

#Preview("Light Mode") {
    HomeView()
        .environmentObject(AuthService())
}

#Preview("Dark Mode") {
    HomeView()
        .environmentObject(AuthService())
        .preferredColorScheme(.dark)
}
