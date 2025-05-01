//
//  SwiftUIView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-04-30.
//

import SwiftUI

struct ColorView: View {
    let color : Color
    
    var body: some View {
        
        Circle()
            .foregroundColor(color)
            .padding()
            .shadow(radius: 10)
            .frame(width: 100,height: 100)
    }
}

#Preview {
    ColorView(color: .red)
}
