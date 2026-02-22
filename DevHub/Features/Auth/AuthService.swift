//
//  AuthService.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import Foundation
import AuthenticationServices
internal import Combine

@MainActor
final class AuthService: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let keychainManager = KeychainManager.shared
    private var authSession: ASWebAuthenticationSession?
    
    override init() {
        super.init()
        checkAuthentication()
    }
    
    // MARK: - Check Authentication
    func checkAuthentication() {
        isAuthenticated = keychainManager.githubToken != nil
    }
    
    // MARK: - Start OAuth Flow
    func startOAuthFlow() {
        let scope = "read:user,repo"
        let authURL = "https://github.com/login/oauth/authorize"
        let params = "client_id=\(Secrets.githubClientID)&redirect_uri=devhub://oauth-callback&scope=\(scope)"
        
        guard let url = URL(string: "\(authURL)?\(params)") else {
            errorMessage = "URL inválida"
            return
        }
        
        isLoading = true
        
        authSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: "devhub"
        ) { [weak self] callbackURL, error in
            Task { @MainActor in
                self?.handleCallback(callbackURL: callbackURL, error: error)
            }
        }
        
        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = false
        authSession?.start()
    }
    
    // MARK: - Handle Callback
    private func handleCallback(callbackURL: URL?, error: Error?) {
        isLoading = false
        
        guard let callbackURL = callbackURL,
              let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "code" })?
                .value else {
            errorMessage = error?.localizedDescription ?? "Erro ao autenticar"
            return
        }
        
        Task {
            await exchangeCodeForToken(code: code)
        }
    }
    
    // MARK: - Exchange Code for Token
    private func exchangeCodeForToken(code: String) async {
        isLoading = true
        
        let url = URL(string: "https://github.com/login/oauth/access_token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "client_id": Secrets.githubClientID,
            "client_secret": Secrets.githubClientSecret,
            "code": code,
            "redirect_uri": "devhub://oauth-callback"
        ]
        
        request.httpBody = try? JSONEncoder().encode(body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(TokenResponse.self, from: data)
            
            keychainManager.githubToken = response.accessToken
            isAuthenticated = true
            isLoading = false
            errorMessage = nil
            
        } catch {
            isLoading = false
            errorMessage = "Erro ao obter token: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Logout
    func logout() {
        keychainManager.clearAll()
        isAuthenticated = false
    }
    
    // MARK: - Preview Support
    #if DEBUG
    static func mock(authenticated: Bool = true) -> AuthService {
        let service = AuthService()
        service.isAuthenticated = authenticated
        return service
    }
    #endif
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension AuthService: ASWebAuthenticationPresentationContextProviding {
    nonisolated func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}

// MARK: - Models
struct TokenResponse: Codable {
    let accessToken: String
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}
