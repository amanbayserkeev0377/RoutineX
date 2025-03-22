//
//  Habit.swift
//  RoutineX
//
//  Created by Aman on 22/3/25.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var goal: Double
    var unit: HabitUnit
    var isCompleted: Bool
    var createdAt: Date
    var startDate: Date
    var reminderTime: Date?
    var activeDays: [Weekday]
    var currentValue: Double
    
    init(
        id: UUID = .init(),
        name: String,
        goal: Double,
        unit: HabitUnit,
        isCompleted: Bool = false,
        createdAt: Date = .now,
        startDate: Date,
        reminderTime: Date? = nil,
        activeDays: [Weekday] = [],
        currentValue: Double = 0
    ) {
        self.id = id
        self.name = name
        self.goal = max(goal, 1)
        self.unit = unit
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.startDate = startDate
        self.reminderTime = reminderTime
        self.activeDays = activeDays
        self.currentValue = currentValue
    }
    
    var isTimerBased: Bool {
        unit == .time
    }
    
    func resetProgress() {
        currentValue = 0
        isCompleted = false
    }
    
    func increment(_ value: Double = 1) {
        currentValue += value
        checkIfCompleted()
    }
    
    func decrement(_ value: Double = 1) {
        currentValue = max(0, currentValue - value)
        isCompleted = false
    }
    
    private func checkIfCompleted() {
        if currentValue >= goal {
            isCompleted = true
        }
    }
}
