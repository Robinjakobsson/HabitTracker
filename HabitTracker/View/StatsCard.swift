//
//  StatsCard.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-05-02.
//

import SwiftUI

struct StatsCard: View {
    let title : String
    let value : String
    let icon : String
    
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .padding(.top)
                .font(.system(size: 35))
            
            Text(value)
                .font(.system(size: 35))
                .bold()
                .padding(.vertical, 10)
            
            Text(title)
                .font(.subheadline)
                .padding(.bottom, 5)
            
                
            
        }
        .frame(width: 100)
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(radius: 5)
        
    }
}

#Preview {
    StatsCard(title: "hello", value: "1", icon: "flame.fill")
}
