//
//  HabitCardView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
//

import SwiftUI
import SwiftData

struct HabitCardView: View {
    @Environment(\.modelContext) private var modelContext
    let habit : Habit?
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let habit = habit {
                    Text(habit.title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: toggleComplete) {
                        Image(systemName: habit.isComplete ? "checkmark.circle.fill" : "circle")
                            .font(.title2)
                            .foregroundColor(habit.isComplete ? .green : .gray)
                            .animation(.easeInOut(duration: 0.2), value: habit.isComplete)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text("Created: \(formattedDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack {
                if let streak = habit?.streak {
                    Text("Streak : \(streak) 🔥")
                        .font(.subheadline)
                        .foregroundColor(habit?.streak ?? 0 < 0 ? .black : .green)
                    
                }
            }
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var formattedDate : String {
        guard let habit = habit else {return ""}
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "sv_SE")
        
        
        return formatter.string(from: habit.createdDate)
    }
    
    func toggleComplete () {
        habit?.markAsComplete(habit: (habit)!)
        do {
            try modelContext.save()
        } catch {
            print(error)
        }
    }
    
}


