//
//  Habit.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-29.
//

import Foundation
import SwiftData

@Model
class Habit {
    @Attribute(.unique) var id: UUID
    var title: String
    var createdDate: Date
    var isComplete: Bool = false
    var completeDate: Date?
    var streak: Int = 0
    var lastReset: Date?
    var days: [Weekday] = []

  
    init(title: String, createdDate: Date = Date(), streak: Int = 0, completeDate: Date? = nil, isComplete: Bool = false, lastReset : Date = Date(), days: [Weekday]) {
        self.id = UUID()
        self.title = title
        self.createdDate = createdDate
        self.streak = streak
        self.completeDate = completeDate
        self.isComplete = isComplete
        self.lastReset = lastReset
        self.days = days
    }
    
    
    
    func markAsComplete(habit : Habit) {
        let today = Date()
           
        let weekdayIndex = Calendar.current.component(.weekday, from: Date()) // Hämtar index för veckans dag
        
        let toDayDay = Weekday.allCases[(weekdayIndex + 5) % 7] // Hämtar dagens dag
        
        guard habit.days.contains(toDayDay) else { // Kollar om vanans dagar innehåller dagens veckodag
            print("Wait until tomorrow! \(toDayDay) \(today)")
            return
        }
        
     
        if let lastCompletedDate = completeDate, Calendar.current.isDateInYesterday(lastCompletedDate) {
            streak += 1
               
        } else {
            streak = 1
        }
        completeDate = today
        isComplete = true
       }
    
    
    func isCompletedToday() -> Bool {
        //First checking if CompleteDate exists, if it does not we stop
        guard let completeDate = completeDate else { return false }
        
        // getting the Calendar for the isDateinToday Function
        let calendar = Calendar.current
        
        // Returning the Answer
        return calendar.isDateInToday(completeDate)
        
        }
    
}

enum Weekday: String, CaseIterable, Codable, Identifiable {
    var id : String {self.rawValue}
    
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var displayName: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        }
    }
}
    

