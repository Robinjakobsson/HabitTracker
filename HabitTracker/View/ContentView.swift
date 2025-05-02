//
//  ContentView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
//

import SwiftUI
import SwiftData

//Veckodagar längst upp och en lista för dagens grejer.
//TODOD LÄGG TILL NÄR habit blev klar


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
                        Button(action: {
                            withAnimation { selectedTab = 0 }
                        }) {
                            Image(systemName: "house")
                                .font(.system(size: 20))
                                .padding()
                                .background(Circle().foregroundColor(selectedTab == 0 ? .green : .clear))
                                .foregroundColor(selectedTab == 0 ? .white : .green)
                        }
                        
                        Button(action : {
                            withAnimation { showingAddSheet = true }
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 30))
                                .padding()
                                .background(Circle().foregroundColor(selectedTab == 2 ? .green : .clear))
                                .foregroundColor(selectedTab == 2 ? .white : .green)
                        }
                        
                        Button(action: {
                            withAnimation { selectedTab = 1 }
                        }) {
                            Image(systemName: "chart.bar")
                                .font(.system(size: 20))
                                .padding()
                                .background(Circle().foregroundColor(selectedTab == 1 ? .green : .clear))
                                .foregroundColor(selectedTab == 1 ? .white : .green)
                        }
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
