//
//  StatsView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-05-01.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \Habit.createdDate, order: .forward) var habits: [Habit]
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack(spacing: 50) {
                    StatsCard(title: "Highest streak", value: "\(highestStreak)", icon: "flame.fill")
                    StatsCard(title: "Total Habits", value: "\(amountOfHabits)", icon: "checkmark.circle.fill")
                    
            }
            Spacer()
        }
    }
        
}
    var highestStreak: Int {
        guard !habits.isEmpty else { return 0 }
        
        return habits.map(\.streak).max() ?? 0
    }
    
    var amountOfHabits : Int {
        guard !habits.isEmpty else {return 0 }
        
        return habits.count
    }
}

#Preview {
    StatsView()
        .modelContainer(for: Habit.self, inMemory: true)
}


