// ActiveDaysViewModel.swift

import Foundation

@MainActor
final class ActiveDaysViewModel: ObservableObject {
    @Published var habit: Habit
    let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    var allSelected: Bool {
        habit.activeDays.count == weekdays.count
    }
    
    var toggleButtonText: String {
        allSelected ? "Deselect All" : "Select All"
    }
    
    func toggleDaySelection(_ day: String) {
        if let existingDay = habit.activeDays.first(where: { $0.day == day }) {
            habit.activeDays.removeAll { $0.id == existingDay.id }
        } else {
            let newDay = ActiveDayEntity(day: day)
            habit.activeDays.append(newDay)
        }
        saveChanges()
    }
    
    func toggleAllDays() {
        habit.activeDays = allSelected ? [] : weekdays.map { ActiveDayEntity(day: $0) }
        saveChanges()
    }
    
    private func saveChanges() {
        let updatedData = HabitUpdateData(
            name: habit.name,
            unit: habit.unit,
            goalValue: habit.goalValue,
            isCompleted: habit.isCompleted,
            createdAt: habit.createdAt,
            reminderTime: habit.reminderTime,
            activeDays: habit.activeDays
        )
        
        SwiftDataManager.shared.updateHabit(habit, with: updatedData)
    }
}
