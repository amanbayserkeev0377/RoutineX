//
//  NewHabitView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var habitName: String = ""
    @State private var selectedIcon: String = "💪"
    @State private var selectedColor: Color = .red
    @State private var selectedGoal: String = "Daily"
    @State private var remindersEnabled: Bool = false
    
    var body: some View {
        VStack {
            // Title
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Text("New Habit")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: { saveHabit() }) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            
            // Habit name
            VStack(alignment: .leading, spacing: 8) {
                Text("NAME")
                    .font(.caption)
                    .foregroundStyle(.gray)
                TextField("Workout", text: $habitName)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            
            // Icon and Color
            HStack(spacing: 15) {
                HabitOptionView(title: "ICON", value: selectedIcon)
                HabitOptionView(title: "COLOR", value: "", color: selectedColor)
            }
            .padding()
            
            // Goal
            VStack(alignment: .leading, spacing: 8) {
                Text("GOAL")
                    .font(.caption)
                    .foregroundStyle(.gray)
                HStack {
                    Text("\(selectedGoal)")
                        .font(.headline)
                    Spacer()
                    Button("Change") {
                        selectedGoal = (selectedGoal == "Daily") ? "Every Day" : "Daily"
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            
            // Reminders
            VStack(alignment: .leading, spacing: 8) {
                Text("REMINDERS")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Toggle("Enable reminders", isOn: $remindersEnabled)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            
            // Add habit button
            Button(action: { saveHabit() }) {
                Text("ADD HABIT")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.horizontal)
            }
            .padding(.top, 10)
        }
        .padding(.bottom, 20)
    }
    
    func saveHabit() {
        // TODO: добавить сохр в firestore
        dismiss()
    }
}

struct HabitOptionView: View {
    var title: String
    var value: String
    var color: Color? = nil
    
    var body: some View {
        VStack {
            if let color = color {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
            } else {
                Text(value)
                    .font(.largeTitle)
            }
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(width: 100, height: 80)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
