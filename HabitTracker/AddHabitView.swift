//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var habitName : String = ""
    @State private var selectedDays: Set<Weekday> = []
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green, .white], startPoint: .topTrailing, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Repeat on:")
                    .font(.title)
                HStack {
                    ForEach(Weekday.allCases) { day in
                        Button(day.displayName) {
                            withAnimation {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                    print("\(day) Removed")
                                } else {
                                    selectedDays.insert(day)
                                    print("\(day) Selected")
                                    
                                }
                            }
                        }
                        .padding(8)
                        .background(selectedDays.contains(day) ? Color.green : Color.gray.opacity(0.2))
                        .foregroundColor(selectedDays.contains(day) ? Color.white : Color.blue)
                        .cornerRadius(8)
                    }
                }
                .padding()
                
                
                TextField("Habit name", text: $habitName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button(action: {
                    withAnimation{
                        addItem()
                    }
                }) {
                    Text("Save")
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(!habitName.isEmpty ?  Color.green : Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                .foregroundColor(!habitName.isEmpty ? Color.white : Color.blue)
                .animation(.smooth(duration: 0.3), value: habitName)
                Spacer()
            }
        }
    }
     func addItem() {
        withAnimation {
            let newHabit = Habit(title: habitName, days: Array(selectedDays))
            modelContext.insert(newHabit)
            print("\(newHabit.title) added")
            
            do {
               try modelContext.save()
            } catch {
                print("Unable to save new habit")
            }
            habitName = ""
            selectedDays.removeAll()
        }
    }
}


#Preview {
    AddHabitView()
}
