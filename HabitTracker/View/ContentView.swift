//
//  ContentView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
//

import SwiftUI
import SwiftData

//Veckodagar längst upp och en lista för dagens grejer.


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdDate, order: .forward) var habits: [Habit]
    
    @State private var selectedDay: Weekday = currentDay()
    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Weekday.allCases) { day in
                            Text(day.displayName)
                                .padding()
                                .background(selectedDay == day ? Color.green : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedDay = day
                                }
                        }
                    }.padding(.horizontal)
                }

                List {
                    ForEach(habitsForSelectedDay) { habit in
                        HabitCardView(habit: habit)
                    }
                    .onDelete(perform: removeHabit)
                }
                .listStyle(.plain)

                Spacer()
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddHabitView()
            }
        }
    }
    func removeHabit(at offsets: IndexSet) {
        for index in offsets {
            let habitToDelete = habits[index]
            modelContext.delete(habitToDelete)
        }
        do {
           try modelContext.save()
        }catch {
            print("Failed to remove")
        }
    }

    var habitsForSelectedDay: [Habit] {
        habits.filter {  $0.days.contains(selectedDay) }
    }

        static func currentDay() -> Weekday {
        let weekdayIndex = Calendar.current.component(.weekday, from: Date())
        return Weekday.allCases[(weekdayIndex + 5) % 7]
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
