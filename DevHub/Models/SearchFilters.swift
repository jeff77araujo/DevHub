//
//  SearchFilters.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/03/26.
//

import Foundation

// MARK: - Search Filters

struct SearchFilters {
    var language: String?
    var minStars: Int?
    var sortBy: SortOption
    
    // MARK: - Language Options
    
    enum Language: String, CaseIterable, Identifiable {
        case all = ""
        case swift = "Swift"
        case python = "Python"
        case javascript = "JavaScript"
        case typescript = "TypeScript"
        case java = "Java"
        case kotlin = "Kotlin"
        case go = "Go"
        case rust = "Rust"
        case cpp = "C++"
        case csharp = "C#"
        
        var id: String { rawValue }
        
        var displayName: String {
            self == .all ? "Todas" : rawValue
        }
    }
    
    // MARK: - Stars Options
    
    enum StarsFilter: Int, CaseIterable, Identifiable {
        case any = 0
        case oneK = 1000
        case fiveK = 5000
        case tenK = 10000
        case fiftyK = 50000
        
        var id: Int { rawValue }
        
        var displayName: String {
            switch self {
            case .any: return "Qualquer"
            case .oneK: return "1K+"
            case .fiveK: return "5K+"
            case .tenK: return "10K+"
            case .fiftyK: return "50K+"
            }
        }
    }
    
    // MARK: - Sort Options
    
    enum SortOption: String, CaseIterable, Identifiable {
        case bestMatch = "Melhor correspondência"
        case stars = "Mais estrelas"
        case updated = "Atualizados recentemente"
        
        var id: String { rawValue }
    }
    
    // MARK: - Default Filters
    
    static let `default` = SearchFilters(
        language: nil,
        minStars: nil,
        sortBy: .bestMatch
    )
    
    // MARK: - Check if filters are active
    
    var hasActiveFilters: Bool {
        language != nil || minStars != nil || sortBy != .bestMatch
    }
    
    // MARK: - Reset filters
    
    mutating func reset() {
        language = nil
        minStars = nil
        sortBy = .bestMatch
    }
}
