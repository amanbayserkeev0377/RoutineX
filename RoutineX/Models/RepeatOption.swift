import Foundation

enum RepeatOption: String, CaseIterable {
    
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    
    func toRecurrenceRule(calendar: Calendar = .current) -> Calendar.RecurrenceRule {
        switch self {
        case .daily:
            return Calendar.RecurrenceRule(calendar: calendar, frequency: .daily, interval: 1)
        case .weekly:
            return Calendar.RecurrenceRule(calendar: calendar, frequency: .weekly, interval: 1)
        case .monthly:
            return Calendar.RecurrenceRule(calendar: calendar, frequency: .monthly, interval: 1)
        }
    }
}
