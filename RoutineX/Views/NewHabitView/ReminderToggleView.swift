// ReminderToggleView.swift

import SwiftData
import SwiftUI

struct ReminderToggleView: View {
    @Bindable var habit: Habit
    @State private var isTimePickerPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Reminder")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: Binding(
                    get: { habit.reminderTime != nil },
                    set: { newValue in
                        if newValue {
                            let newTime = Date()
                            habit.reminderTime = newTime
                            SwiftDataManager.shared.updateHabitReminder(habit, reminderTime: newTime)
                        } else {
                            habit.reminderTime = nil
                            SwiftDataManager.shared.updateHabitReminder(habit, reminderTime: nil)
                        }
                    }
                ))
                .labelsHidden()
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if habit.reminderTime != nil {
                Button(
                    action: { isTimePickerPresented = true },
                    label: {
                        HStack {
                            Spacer()
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.primary)
                                Text(habit.reminderTime ?? Date(), style: .time)
                                    .foregroundColor(.primary)
                                    .animation(.easeInOut, value: habit.reminderTime)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                )
                .sheet(
                    isPresented: $isTimePickerPresented,
                    content: {
                        TimePickerView(selectedTime: Binding<Date>(
                            get: { habit.reminderTime ?? Date() },
                            set: { newTime in
                                habit.reminderTime = newTime
                                SwiftDataManager.shared.updateHabitReminder(habit, reminderTime: newTime)
                            }
                        ))
                    }
                )
            }
        }
    }
}

#Preview {
    ReminderToggleView(habit: .init(
        name: "Brush teeth",
        unit: "count",
        goalValue: 2,
        isCompleted: false,
        createdAt: Date(),
        reminderTime: Date(),
        activeDays: []
    ))
}
