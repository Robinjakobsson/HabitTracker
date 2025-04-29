//
//  ContentView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdDate, order: .forward) var habits: [Habit]
    @State var showingAddSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(habits) { habit in
                        Text("\(habit.title)")
                    }
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action : { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddHabitView()
            }
        }
        
    }
    
    
// MARK: - CRUD OPERATIONS

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
           
            }
        }
    }

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
