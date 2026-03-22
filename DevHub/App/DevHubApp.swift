//
//  DevHubApp.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import SwiftUI
import SwiftData

@main
struct DevHubApp: App {
    @StateObject private var authService = AuthService()
    
    // SwiftData ModelContainer
    let modelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteRepository.self,
            SearchHistory.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                MainTabView()
                    .environmentObject(authService)
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
        .modelContainer(modelContainer)
    }
}
