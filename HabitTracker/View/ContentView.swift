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
            VStack {
                ProgressView(value: completedHabitsToday)
                    .progressViewStyle(.linear)
                    .animation(.easeInOut, value: completedHabitsToday)
                    .tint(.green)
                
                List {
                    ForEach(habits) { habit in
                        HabitCardView(habit: habit)
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                .navigationTitle("Habits")
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action : { showingAddSheet = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(.green)
                            
                        }
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    AddHabitView()
                }
            }
        }
        
    }
    
    
    private var completedHabitsToday: Double {
            let totalHabits = habits.count
            let completedHabits = habits.filter { $0.isCompletedToday() }.count
            return totalHabits > 0 ? Double(completedHabits) / Double(totalHabits) : 0
        }
    
// MARK: - CRUD OPERATIONS

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let habitToDelete = habits[index]
                modelContext.delete(habitToDelete)
                }
            }
        }
    func dailyReset(for habit: Habit) {
        // fetching Calendar class
        let calendar = Calendar.current
        
        //Getting todays date without the time
        let today = calendar.startOfDay(for: Date())
        // getting the date of lastReset without the time aswell
        let lastreset = calendar.startOfDay(for: habit.lastReset ?? Date())
        
        // if todays date is greater than lastresets date we reset the boolean and set the lastreset to today
        if today > lastreset {
            habit.isComplete = false
            habit.lastReset = today
            }
        }
    }

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
