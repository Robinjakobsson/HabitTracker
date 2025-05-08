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
    @State private var lastFinish: Date = Date()
    var body: some View {
        
        //Bakgrund
        ZStack {
            LinearGradient(colors: [.green, .white], startPoint: .topTrailing, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Repeat on:")
                    .font(.title)
//MARK: - Weekdays
                HStack {
                    // För varje veckodag så gör vi en knapp och lägger in i ett set av Weekday
                    // Kan ej vara dubbleter i Set
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
                        .background(selectedDays.contains(day) ? Color.green : Color.clear)
                        .foregroundColor(selectedDays.contains(day) ? Color.white : Color.black)
                        .cornerRadius(8)
                    }
                }
                Divider()
                    .padding()
                
//MARK: - Textfield
                TextField("Habit name", text: $habitName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
//MARK: - Datepicker
                //Date picker som bara visar timme och minut
                DatePicker("Due time", selection: $lastFinish, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    
                //Knapp som visas när Textfield inte är tomt
                Button(action: {
                    withAnimation{
                        add()
                    }
                }) {
                    Text("Save")
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(!habitName.isEmpty ?  Color.green : Color(.clear))
                .cornerRadius(10)
                .padding()
                .foregroundColor(!habitName.isEmpty ? Color.white : Color.clear)
                .animation(.smooth(duration: 0.7), value: habitName)
                Spacer()
            }
        }
    }
//MARK: - AddItem function
            func addItem() {
                withAnimation {
                    let newHabit = Habit(title: habitName, days: Array(selectedDays),finishTime: lastFinish)
                    modelContext.insert(newHabit)
                    print("\(newHabit.title) added")
                    
//MARK: - Notification Manager
                    // Här lägger jag till en notis för Habiten,
                    NotificationManager.shared.scheduleNotification(title: "Habit reminder", body: "\(habitName) is due Soon!", date: lastFinish, identifier: newHabit.id.uuidString)
                    
                    do {
                        // Använder denna för att säkerställa att det verkligen sparas.
                        try modelContext.save()
                    } catch {
                        print("Unable to save new habit")
                    }
                    habitName = ""
                    selectedDays.removeAll()
                    dismiss()
                    
                }
            }
    //Gör flera habits av vald dag
    func add() {
        withAnimation {
            for day in selectedDays {
                let newHabit = Habit(title: habitName, days: [day], finishTime: lastFinish)
                
                modelContext.insert(newHabit)
                
                NotificationManager.shared.scheduleNotification(title: "Habit Reminder", body: "\(habitName) is due soon!", date: lastFinish, identifier: newHabit.id.uuidString)
                
                do {
                    try modelContext.save()
                } catch {
                    print("Unable to save new habit!")
                }
            }
            habitName = ""
            selectedDays.removeAll()
            dismiss()
        }
    }
}
    



#Preview {
    AddHabitView()
}
