//
//  Item.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
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
