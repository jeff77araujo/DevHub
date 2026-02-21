//
//  Item.swift
//  DevHub
//
//  Created by Jefferson Oliveira de Araujo on 21/02/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
