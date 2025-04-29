//
//  Habit.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
//

import Foundation
import SwiftData

@Model
class Habit {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var title: String
    var createdDate: Date
    var completeDate: Date
    var streak: Int

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.createdDate = Date()
        self.completeDate = Date()
        self.streak = 0
    }
}
