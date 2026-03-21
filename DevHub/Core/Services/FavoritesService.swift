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
        
    init() {}
    
    // MARK: - Check if Favorite
    
    func isFavorite(repoId: String, context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<FavoriteRepository>(
            predicate: #Predicate { $0.id == repoId }
        )
        
        let count = (try? context.fetchCount(descriptor)) ?? 0
        return count > 0
    }
    
    // MARK: - Add Favorite
    
    func addFavorite(_ repository: Repository, context: ModelContext) throws {
        let favorite = repository.toFavorite()
        context.insert(favorite)
        try context.save()
    }
    
    // MARK: - Remove Favorite
    
    func removeFavorite(repoId: String, context: ModelContext) throws {
        let descriptor = FetchDescriptor<FavoriteRepository>(
            predicate: #Predicate { $0.id == repoId }
        )
        
        guard let favorite = try context.fetch(descriptor).first else {
            return
        }
        
        context.delete(favorite)
        try context.save()
    }
    
    // MARK: - Toggle Favorite
    
    func toggleFavorite(_ repository: Repository, context: ModelContext) throws {
        if isFavorite(repoId: repository.id, context: context) {
            try removeFavorite(repoId: repository.id, context: context)
        } else {
            try addFavorite(repository, context: context)
        }
    }
    
    // MARK: - Fetch All Favorites
    
    func fetchAllFavorites(context: ModelContext) throws -> [Repository] {
        let descriptor = FetchDescriptor<FavoriteRepository>(
            sortBy: [SortDescriptor(\.favoritedAt, order: .reverse)]
        )
        
        let favorites = try context.fetch(descriptor)
        return favorites.compactMap { $0.toRepository() }
    }
}
