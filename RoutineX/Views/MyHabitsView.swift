//
//  MyHabitsView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct MyHabitsView: View {
    @EnvironmentObject var habitViewModel: HabitViewModel
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showNewHabitView = false
    @State private var showSettings = false
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            let habits = habitViewModel.habits.filter { $0.id != nil }
            
            ZStack {
                List {
                    ForEach(habits.compactMap { $0.id }, id: \.self) { id in
                        if let habit = habits.first(where: { $0.id == id }) {
                            HabitRowView(habit: habit, habitViewModel: habitViewModel)
                        }
                    }
                    .onDelete(perform: deleteHabit)
                }
                .navigationTitle(formattedDate)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { showSettings.toggle() }) {
                            Image(systemName: "gearshape")
                        }
                    }
                    
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showDatePicker.toggle() }) {
                            Image(systemName: "calendar")
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showNewHabitView = true }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.blue)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .sheet(isPresented: $showNewHabitView) {
            NewHabitView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        withAnimation {
            offsets.map { habitViewModel.habits[$0] }.forEach { habit in
                habitViewModel.deleteHabit(habit)
            }
        }
    }
}




struct HabitRowView: View {
    let habit: HabitEntity
    let habitViewModel: HabitViewModel
    
    var body: some View {
        HStack {
            Text(habit.icon ?? "⬜")
                .font(.title2)
            
            VStack(alignment: .leading) {
                let title = habit.title ?? "Untitled Habit"
                let progressText = "\(Int(habit.progress))/\(Int(habit.goal)) completed"
                
                Text(title)
                    .font(.headline)
                Text(progressText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
            Button(action: {
                habitViewModel.toggleHabitCompletion(habit)
            }) {
                Image(systemName: habit.progress >= habit.goal ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.progress >= habit.goal ? .green : .gray)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
    }
}
