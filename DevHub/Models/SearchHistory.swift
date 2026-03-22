//
//  SearchHistory.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/03/26.
//

import Foundation
import SwiftData

@Model
final class SearchHistory {
    var id: UUID
    var query: String
    var searchedAt: Date
    
    init(query: String) {
        self.id = UUID()
        self.query = query
        self.searchedAt = Date()
    }
}

// MARK: - Extensions

extension SearchHistory {
    /// Formata data de busca
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: searchedAt, relativeTo: Date())
    }
}
