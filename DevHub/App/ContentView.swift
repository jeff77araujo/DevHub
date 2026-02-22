//
//  ContentView.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.circle")
                }
            
            Text("Repositórios")
                .tabItem {
                    Label("Repos", systemImage: "folder")
                }
            
            Text("Busca")
                .tabItem {
                    Label("Busca", systemImage: "magnifyingglass")
                }
        }
        .tint(AppTheme.Colors.primary)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService())
}
