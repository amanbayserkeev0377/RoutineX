//
//  NewHabitView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var habitViewModel: HabitViewModel

    @State private var habitName: String = ""
    @State private var selectedIcon: String = "🔥"
    @State private var selectedColor: Color = .blue
    @State private var selectedGoal: String = "Daily"

    let icons = ["🔥", "💪", "📖", "🧘‍♂️", "🏃‍♂️", "🍎", "💤"]
    let colors: [Color] = [.red, .blue, .green, .orange, .purple]

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Habit name", text: $habitName)
                        .padding(.vertical, 8)
                }

                Section(header: Text("ICON")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(icons, id: \.self) { icon in
                                Text(icon)
                                    .font(.largeTitle)
                                    .padding()
                                    .background(icon == selectedIcon ? Color(.systemGray5) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section(header: Text("COLOR")) {
                    HStack {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black.opacity(color == selectedColor ? 1 : 0), lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section(header: Text("GOAL")) {
                    Picker("Goal", selection: $selectedGoal) {
                        Text("Daily").tag("Daily")
                        Text("Every Day").tag("Every Day")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { saveHabit() }
                        .bold()
                }
            }
        }
    }

    private func saveHabit() {
        habitViewModel.addHabit(title: habitName, icon: selectedIcon, color: selectedColor.description, goal: 1)
        dismiss()
    }
}
