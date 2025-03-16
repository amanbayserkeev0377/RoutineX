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
        if habit.activeDays.contains(day) {
            habit.activeDays.removeAll { $0 == day }
        } else {
            habit.activeDays.append(day)
        }
        saveChanges()
    }
    
    func toggleAllDays() {
        habit.activeDays = allSelected ? [] : weekdays
        saveChanges()
    }
    
    private func saveChanges() {
        SwiftDataManager.shared.updateHabitDays(habit, activeDays: habit.activeDays)
    }
}
