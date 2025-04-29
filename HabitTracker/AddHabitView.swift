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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("New habit")
                    .font(.title)
                    .bold()
                
                TextField("Name of Habit", text: $habitName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {addItem()}) {
                    Text("Save")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(habitName.isEmpty ? Color.gray.opacity(0.5) :Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .animation(.easeInOut(duration: 0.3), value: habitName)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            
        }
        
        
            }
    private func addItem() {
        withAnimation {
            let newHabit = Habit(title: habitName)
            modelContext.insert(newHabit)
            print("\(newHabit.title) added")
            
            do {
               try modelContext.save()
            } catch {
                print("Unable to save new habit")
            }
        }
    }
        }

#Preview {
    AddHabitView()
}
