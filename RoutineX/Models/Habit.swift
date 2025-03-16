import Foundation
import SwiftData

@Model
final class Habit {
    var name: String
    var unit: String
    var goalValue: Int
    var isCompleted: Bool
    var createdAt: Date
    var reminderTime: Date?
    
    init(name: String, unit: String, goalValue: Int, isCompleted: Bool, createdAt: Date, reminderTime: Date? = nil) {
        self.name = name
        self.unit = unit
        self.goalValue = goalValue
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.reminderTime = reminderTime
    }
}
