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

  
    init(title: String, createdDate: Date = Date(), streak: Int = 0, completeDate: Date? = nil, isComplete: Bool = false) {
        self.id = UUID()
        self.title = title
        self.createdDate = createdDate
        self.streak = streak
        self.completeDate = completeDate
        self.isComplete = isComplete
    }
    
    
    /**
            Function to set a Habit as complete and increase the streak
            Compares The last completed Date to
     */
    func markAsComplete() {
        // getting todays Date
           let today = Date()
           
        // first Checking if lastCompletedDate is existing, then checking if it was Yesterday, if so streak +=1 else streak gets set to 1
           if let lastCompletedDate = completeDate, Calendar.current.isDateInYesterday(lastCompletedDate) {
               streak += 1
           } else {
               streak = 1
           }
           completeDate = today
           isComplete = true
       }
    
    /**
     Function to check if the Habit was done today,
     */
    func isCompletedToday() -> Bool {
        //First checking if CompleteDate exists, if it does not we stop
        guard let completeDate = completeDate else { return false }
        
        // getting the Calendar for the isDateinToday Function
        let calendar = Calendar.current
        
        // Returning the Answer
        return calendar.isDateInToday(completeDate)
        
    }
    
}
