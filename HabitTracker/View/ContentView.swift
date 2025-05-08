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
    @State private var selectedTab: Int = 0
    
    var body: some View {
NavigationView {
    ZStack {
//MARK: - selected Tab = 0 First view
        if selectedTab == 0 {
            LinearGradient(colors: [.green, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                    
            VStack {
                HStack {
                    // Alla Veckodagar, gör en knapp av alla dagar i en HSTACK
                ForEach(Weekday.allCases) { day in
                    Button(day.displayName) {
                    withAnimation {
                        selectedDay = day
                    }
                }
                .padding(8)
                .background(selectedDay == day ? Color.green : Color.clear)
                .foregroundColor(selectedDay == day ? Color.white : .black)
                }
                                
            }
            .padding(.horizontal)
            Divider()
                        
                List {
                    // Lista med Habits som vi visar upp med en habitCardView
                    ForEach(habitsForSelectedDay) { habit in
                        HabitCardView(habit: habit)
                            .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: removeHabit)
                        }
                        .listStyle(.plain)
                        
                        Spacer()
                    }
                    .navigationTitle("Habits")
                    
                } else if selectedTab == 1 {
//MARK: - STATSVIEW // Tab 1
                    // Här är statsViewen
                    StatsView()
                        .navigationTitle("Stats")
                }
                
//MARK: - BOTTOM TAB
        VStack {
            Spacer()
            HStack {
                    // Här börjar tabViewen med 3 knappar
                AnimatingButton(forColor: .green, action: {selectedTab = 0}, selectedTab: 1, icon: "house")
                    .background(Circle().foregroundColor(selectedTab == 0 ? .green : .clear))
                    .foregroundColor(selectedTab == 0 ? .white : .green)
                        
                AnimatingButton(forColor: .green, action: {showingAddSheet = true}, selectedTab: 2, icon: "plus")
                    .background(Circle().foregroundColor(selectedTab == 2 ? .green : .clear))
                    .foregroundColor(selectedTab == 2 ? .white : .green)
                        
                AnimatingButton(forColor: .green, action: {selectedTab = 1}, selectedTab: 1, icon: "chart.bar")
                    .background(Circle().foregroundColor(selectedTab == 1 ? .green : .clear))
                    .foregroundColor(selectedTab == 1 ? .white : .green)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .shadow(radius: 10)
                }
            }
            .onAppear {
                // varenda gång man startar appen så kör vi Funktionen för att reseta
                resetDaily(habits: habits)
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

    // Filtrerar habits för dagen
    var habitsForSelectedDay: [Habit] {
        habits.filter {  $0.days.contains(selectedDay) }
    }

    // Statisk funktion som hämtar indexet för veckan och använder indexet för att få en dag i enum klassen
        static func currentDay() -> Weekday {
        let weekdayIndex = Calendar.current.component(.weekday, from: Date())
        return Weekday.allCases[(weekdayIndex + 5) % 7]
    }
//MARK: - Resets for habits
    func resetDaily(habits: [Habit]) {
        let calendar = Calendar.current
        let today = Date()
        
        for habit in habits {
            if let lastReset = habit.lastReset {
                if !calendar.isDateInToday(lastReset) {
                    habit.isComplete = false
                    habit.lastReset = today
                }
            } else {
                habit.isComplete = false
                habit.lastReset = today
            }
        }
    }
    // Funktion för att reseta alla habits direkt, kör i .onAppear
    func resetAllHabits(habits: [Habit]) {
        let now = Date()

        for habit in habits {
            habit.isComplete = false
            habit.lastReset = now
        }

        do {
            try modelContext.save()
            print("Habits successfully reset.")
        } catch {
            print("Failed to reset habits: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
