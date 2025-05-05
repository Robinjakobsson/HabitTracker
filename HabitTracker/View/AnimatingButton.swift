//
//  AnimatingButton.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-05-05.
//

import SwiftUI

struct AnimatingButton: View {
    let forColor : Color?
    let action : () -> Void
    let selectedTab : Int
    let icon : String
    
    var body: some View {
        
        
        Button(action : {
            withAnimation { action() }
        }) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .padding()
                
        }
    }
}
