//
//  MainTabView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var showNewHabitView = false
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                MyHabitsView()
            }
            
            Tab("Add", systemImage: "plus") {
                Button(action: { showNewHabitView = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                }
                .sheet(isPresented: $showNewHabitView) {
                    NewHabitView()
                }
            }
            
            Tab("Stats", systemImage: "chart.bar") {
                StatisticsView()
            }
        }
    }
}
