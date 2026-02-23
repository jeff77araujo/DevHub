//
//  FavoritesService.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 22/02/26.
//

import Foundation
import SwiftData

@MainActor
final class FavoritesService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Check if Favorite
    func isFavorite(repoId: String) -> Bool {
        let descriptor = FetchDescriptor<FavoriteRepository>(
            predicate: #Predicate { $0.id == repoId }
        )
        
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        return count > 0
    }
    
    // MARK: - Add Favorite
    func addFavorite(_ repository: Repository) throws {
        let favorite = repository.toFavorite()
        modelContext.insert(favorite)
        try modelContext.save()
    }
    
    // MARK: - Remove Favorite
    func removeFavorite(repoId: String) throws {
        let descriptor = FetchDescriptor<FavoriteRepository>(
            predicate: #Predicate { $0.id == repoId }
        )
        
        guard let favorite = try modelContext.fetch(descriptor).first else {
            return
        }
        
        modelContext.delete(favorite)
        try modelContext.save()
    }
    
    // MARK: - Toggle Favorite
    func toggleFavorite(_ repository: Repository) throws {
        if isFavorite(repoId: repository.id) {
            try removeFavorite(repoId: repository.id)
        } else {
            try addFavorite(repository)
        }
    }
    
    // MARK: - Fetch All Favorites
    func fetchAllFavorites() throws -> [Repository] {
        let descriptor = FetchDescriptor<FavoriteRepository>(
            sortBy: [SortDescriptor(\.favoritedAt, order: .reverse)]
        )
        
        let favorites = try modelContext.fetch(descriptor)
        return favorites.map { $0.toRepository() }
    }
}
