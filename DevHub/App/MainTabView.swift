import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Repositórios")
                .tabItem {
                    Label("Repos", systemImage: "folder.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.circle.fill")
                }
        }
        .tint(AppTheme.Colors.primary)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService())
}
