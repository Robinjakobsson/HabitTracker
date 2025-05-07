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
        //Bakgrund
        ZStack {
            LinearGradient(colors: [.green, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack(spacing: 50) {
                    StatsCard(title: "Highest streak", value: "\(highestStreak)", icon: "flame.fill")
                    StatsCard(title: "Total Habits", value: "\(amountOfHabits)", icon: "checkmark.circle.fill")
                    
            }
                VStack {
                    Text("Longest lasting Habit")
                        .font(.headline)
                        .padding()
            
                    if let bestHabit = bestHabit {
                        Text("\(bestHabit.title)")
                            .font(.system(size: 40))
                            .bold()
                            .padding()
                        
                        Text("\(bestHabit.streak)")
                            .bold()
                            .padding()
                        
            
                        Text("Days: \(bestHabit.days[0])")
                            .padding()
                        }
                    }
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
                        
        
                
                
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
    
    var bestHabit: Habit? {
        habits.max(by: {$0.streak < $1.streak})
    }
    
}

#Preview {
    StatsView()
        .modelContainer(for: Habit.self, inMemory: true)
}


