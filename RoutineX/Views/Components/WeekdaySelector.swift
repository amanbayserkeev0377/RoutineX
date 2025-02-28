import SwiftUI

struct WeekdaySelector: View {
    @Binding var selectedDays: Set<Weekday>
    
    let days: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                Text(day.shortName)
                    .frame(width: 40, height: 40)
                    .background(selectedDays.contains(day) ? Color.blue : Color(.systemGray5))
                    .clipShape(Circle())
                    .foregroundStyle(selectedDays.contains(day) ? .white : .black)
                    .onTapGesture {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }
            }
        }
    }
}


enum Weekday: String, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var shortName: String {
        switch self {
        case .monday: return "Mo"
        case .tuesday: return "Tu"
        case .wednesday: return "We"
        case .thursday: return "Th"
        case .friday: return "Fr"
        case .saturday: return "Sa"
        case .sunday: return "Su"
        }
    }
}
