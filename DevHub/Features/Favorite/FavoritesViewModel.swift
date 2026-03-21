//
//  FavoritesViewModel.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 15/03/26.
//

import Foundation
import SwiftData
internal import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var favorites: [Repository] = []
    @Published var filteredFavorites: [Repository] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .dateAdded
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let favoritesService: FavoritesService
    
    // MARK: - Sort Options
    enum SortOption: String, CaseIterable {
        case dateAdded = "Data Adicionado"
        case name = "Nome"
        case stars = "Stars"
        
        var systemImage: String {
            switch self {
            case .dateAdded: return "clock.fill"
            case .name: return "textformat.abc"
            case .stars: return "star.fill"
            }
        }
    }
    
    // MARK: - Initialization
    init(favoritesService: FavoritesService) {
        self.favoritesService = favoritesService
    }
    
    // MARK: - Public Methods
    
    /// Carrega todos os favoritos do SwiftData
    func loadFavorites(context: ModelContext) {
        print("🔄 Carregando favoritos...")
        isLoading = true
        errorMessage = nil
        
        do {
            let favRepos = try favoritesService.fetchAllFavorites(context: context)
            
            favorites = favRepos
            applyFiltersAndSort()
            isLoading = false
        } catch {
            errorMessage = "Erro ao carregar favoritos: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// Remove favorito
    func removeFavorite(_ repository: Repository, context: ModelContext) {
        print("🗑️ Tentando remover: \(repository.name)")
        
        do {
            try favoritesService.removeFavorite(repoId: repository.id, context: context)
            
            // Remove da lista local
            favorites.removeAll { $0.id == repository.id }
            applyFiltersAndSort()
        } catch {
            errorMessage = "Erro ao remover favorito: \(error.localizedDescription)"
        }
    }
    
    /// Atualiza busca
    func updateSearch(_ text: String) {
        searchText = text
        applyFiltersAndSort()
    }
    
    /// Atualiza ordenação
    func updateSort(_ option: SortOption) {
        sortOption = option
        applyFiltersAndSort()
    }
    
    /// Limpa busca
    func clearSearch() {
        searchText = ""
        applyFiltersAndSort()
    }
    
    // MARK: - Private Methods
    
    /// Aplica filtros e ordenação
    private func applyFiltersAndSort() {
        var result = favorites
        
        // Filtrar por busca
        if !searchText.isEmpty {
            result = result.filter { repo in
                repo.name.localizedCaseInsensitiveContains(searchText) ||
                repo.description?.localizedCaseInsensitiveContains(searchText) == true ||
                repo.owner.login.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Ordenar
        switch sortOption {
        case .dateAdded:
            // Usar updatedAt (que vem do favoritedAt no FavoriteRepository)
            result.sort { ($0.updatedAt ?? Date.distantPast) > ($1.updatedAt ?? Date.distantPast) }
            
        case .name:
            result.sort { $0.name.lowercased() < $1.name.lowercased() }
            
        case .stars:
            result.sort { $0.stargazerCount > $1.stargazerCount }
        }
        
        filteredFavorites = result
    }
}
