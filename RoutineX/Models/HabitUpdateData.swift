// HabitUpdateData.swift 

import Foundation

struct HabitUpdateData {
    var name: String
    var unit: String
    var goalValue: Int
    var isCompleted: Bool
    var createdAt: Date
    var reminderTime: Date?
    var activeDays: [ActiveDayEntity]
}
