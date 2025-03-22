//
//  HabitViewModel.swift
//  RoutineX
//
//  Created by Aman on 22/3/25.
//

import Foundation
import SwiftData

@Observable
final class HabitViewModel {
    var habits: [Habit] = []
    var currentDate: Date = .now

    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }

    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
    }

    func habitsForToday() -> [Habit] {
        let calendar = Calendar.current
        let todayWeekday = calendar.component(.weekday, from: currentDate)
        let todayEnum = Weekday.all()[safe: todayWeekday - 1] ?? .monday

        return habits.filter { habit in
            guard habit.startDate <= currentDate else { return false }
            return habit.activeDays.contains(todayEnum)
        }
    }

    func resetAllProgress() {
        for habit in habits {
            habit.resetProgress()
        }
    }
}
