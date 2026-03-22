//
//  SearchViewModel.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/03/26.
//

import SwiftUI
import SwiftData
internal import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var searchText: String = ""
    @Published var repositories: [Repository] = []
    @Published var searchHistory: [SearchHistory] = []
    @Published var filters = SearchFilters.default
    @Published var showFilters = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    
    private let searchService = GitHubSearchService()
    private var modelContext: ModelContext?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupDebounce()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadSearchHistory()
    }
    
    // MARK: - Debounce Setup
    
    private func setupDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                
                if query.count >= 2 {
                    Task {
                        await self.performSearch(query: query)
                    }
                } else if query.isEmpty {
                    self.repositories = []
                    self.errorMessage = nil
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Search
    
    func performSearch(query: String) async {
        guard !query.isEmpty, query.count >= 2 else {
            repositories = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await searchService.searchRepositories(
                query: query,
                language: filters.language,
                minStars: filters.minStars,
                orderBy: convertSortOption(filters.sortBy)
            )
            
            repositories = results
            
            // Atualizar estados de favoritos
            if let context = modelContext {
                updateFavoriteStates(modelContext: context)
            }
            
            // Salvar no histórico
            saveToHistory(query: query)
            
        } catch {
            errorMessage = error.localizedDescription
            repositories = []
        }
        
        isLoading = false
    }
    
    // MARK: - Convert Sort Option
    
    private func convertSortOption(_ option: SearchFilters.SortOption) -> SearchOrder {
        switch option {
        case .bestMatch:
            return .bestMatch
        case .stars:
            return .stars
        case .updated:
            return .updated
        }
    }
    
    // MARK: - History Management
    
    private func loadSearchHistory() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<SearchHistory>(
            sortBy: [SortDescriptor<SearchHistory>(\.searchedAt, order: .reverse)]
        )
        
        do {
            searchHistory = try context.fetch(descriptor)
        } catch {
            print("❌ Erro ao carregar histórico: \(error)")
        }
    }
    
    private func saveToHistory(query: String) {
        guard let context = modelContext else { return }
        
        // Verificar se já existe
        let existingHistory = searchHistory.first { $0.query.lowercased() == query.lowercased() }
        
        if let existing = existingHistory {
            // Atualizar searchedAt
            existing.searchedAt = Date()
        } else {
            // Criar novo
            let newHistory = SearchHistory(query: query)
            context.insert(newHistory)
        }
        
        // Salvar
        do {
            try context.save()
            loadSearchHistory()
        } catch {
            print("❌ Erro ao salvar histórico: \(error)")
        }
    }
    
    func removeFromHistory(_ history: SearchHistory) {
        guard let context = modelContext else { return }
        
        context.delete(history)
        
        do {
            try context.save()
            loadSearchHistory()
        } catch {
            print("❌ Erro ao remover do histórico: \(error)")
        }
    }
    
    func clearHistory() {
        guard let context = modelContext else { return }
        
        searchHistory.forEach { context.delete($0) }
        
        do {
            try context.save()
            searchHistory = []
        } catch {
            print("❌ Erro ao limpar histórico: \(error)")
        }
    }
    
    func selectHistoryItem(_ history: SearchHistory) {
        searchText = history.query
    }
    
    // MARK: - Filters
    
    func updateSortBy(_ sortBy: SearchFilters.SortOption) {
        filters.sortBy = sortBy
        
        if !searchText.isEmpty {
            Task {
                await performSearch(query: searchText)
            }
        }
    }
    
    func resetFilters() {
        filters.reset()
        
        if !searchText.isEmpty {
            Task {
                await performSearch(query: searchText)
            }
        }
    }
    
    // MARK: - Clear Search
    
    func clearSearch() {
        searchText = ""
        repositories = []
        errorMessage = nil
    }
    
    // MARK: - Update Favorite States
    
    /// Atualiza estados de favoritos comparando com SwiftData
    func updateFavoriteStates(modelContext: ModelContext) {
        let favoritesService = FavoritesService()
        
        repositories = repositories.map { repo in
            var mutableRepo = repo
            mutableRepo.isFavorite = favoritesService.isFavorite(
                repoId: repo.id,
                context: modelContext
            )
            return mutableRepo
        }
    }
    
    // MARK: - Toggle Favorite
    
    func toggleFavorite(_ repository: Repository, modelContext: ModelContext) {
        let favoritesService = FavoritesService()
        
        do {
            try favoritesService.toggleFavorite(repository, context: modelContext)
            print("✅ Favorito atualizado: \(repository.name)")
            
            // Atualizar UI imediatamente
            if let index = repositories.firstIndex(where: { $0.id == repository.id }) {
                repositories[index].isFavorite.toggle()
                print("  - \(repositories[index].isFavorite)")
            }
        } catch {
            print("❌ Erro ao favoritar: \(error)")
        }
    }
}
