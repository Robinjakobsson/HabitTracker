//
//  StatsView.swift
//  HabitTracker
//
//  Created by Robin jakobsson on 2025-05-01.
//

import SwiftUI

//TODO Friday

// Gör klart Statsview så man ser högsta streaken som man gjort
// Gör om TabView så den syns i botten här med
// Lägg till bakgrund

struct StatsView: View {
    var body: some View {
        GridLayout {
            GridRow {
                Text("Hello")
                Image(systemName: "circle.fill")
            }
            .frame(width: 100, height: 100)
            .padding()
            .background(Color(.systemGray6))
            
            GridRow {
                Text("Hello")
            }
            .frame(width: 100, height: 100)
            .padding()
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    StatsView()
}
