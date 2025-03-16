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

    private var activeDaysRaw: String = "[]"
    private var _cachedActiveDays: [String]?

    var activeDays: [String] {
        get {
            if let cachedDays = _cachedActiveDays {
                return cachedDays
            }
            let decoded = (try? JSONDecoder().decode([String].self, from: Data(activeDaysRaw.utf8))) ?? []
            _cachedActiveDays = decoded
            return decoded
        }
        set {
            activeDaysRaw = (try? String(data: JSONEncoder().encode(newValue), encoding: .utf8)) ?? "[]"
            _cachedActiveDays = newValue
        }
    }

    init(name: String,
         unit: String,
         goalValue: Int,
         isCompleted: Bool,
         createdAt: Date,
         reminderTime: Date? = nil,
         activeDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]) {
        self.name = name
        self.unit = unit
        self.goalValue = goalValue
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.reminderTime = reminderTime
        self.activeDays = activeDays
    }
}
