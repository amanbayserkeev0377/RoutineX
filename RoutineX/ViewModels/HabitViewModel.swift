import SwiftData
// HabitViewModel.swift

import SwiftUI

@MainActor
@Observable
class HabitViewModel {
    var habits: [Habit] = []
    
    init() {
        loadHabits()
    }
    
    func loadHabits() {
        habits = SwiftDataManager.shared.fetchHabits()
    }
    
    func addHabit(with data: HabitUpdateData) {
        SwiftDataManager.shared.addHabit(with: data)
        loadHabits()
    }
    
    func updateHabit(_ habit: Habit, with data: HabitUpdateData) {
        SwiftDataManager.shared.updateHabit(habit, with: data)
        loadHabits()
    }
    
    func deleteHabit(_ habit: Habit) {
        SwiftDataManager.shared.deleteHabit(habit)
        loadHabits()
    }
}
