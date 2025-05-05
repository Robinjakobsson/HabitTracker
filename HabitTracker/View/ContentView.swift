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
                                
                            }.padding(.horizontal)
                        
                        Divider()
                        
                        List {
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
                    StatsView()
                        .navigationTitle("Stats")
                }
                
//MARK: - BOTTOM TAB
                VStack {
                    Spacer()
                    HStack {
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
