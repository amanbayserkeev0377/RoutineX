import SwiftUI

enum GoalUnit: String, CaseIterable {
    case count = "Count"
    case time = "Time"
    case custom = "Custom unit"
}

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var habitViewModel: HabitViewModel
    
    var habitToEdit: HabitEntity?
    
    @State private var habitName: String = ""
    @State private var selectedEmoji: String = ""
    @State private var selectedColor: Color? = nil
    @State private var repeatOption: RepeatOption = .daily
    @State private var selectedDays: Set<Weekday> = []
    @State private var selectedMonthDays: Set<Int> = []
    
    @State private var goalValue: Int = 1
    @State private var goalUnit: GoalUnit = .count
    @State private var customUnit: String = ""
    @State private var timeGoal: TimeInterval = 0
    @State private var showTimePicker = false
    
    @FocusState private var isTextFieldFocused: Bool
        
    var isDoneButtonEnabled: Bool {
        return !habitName.isEmpty
    }
    
    var formattedTime: String {
        let hours = Int(timeGoal) / 3600
        let minutes = (Int(timeGoal) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Emoji Picker
                EmojiTextField(text: $selectedEmoji)
                    .frame(width: 80, height: 80)
                    .background((selectedColor ?? .gray).opacity(0.2))
                    .clipShape(Circle())
                    .padding(.top, 10)
                
                // Habit name
                TextField("Habit Name", text: $habitName)
                    .font(.title2.weight(.semibold))
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                
                // Goal Section
                VStack(spacing: 10) {
                    Text("Goal")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Count and Time
                    if goalUnit == .count {
                        HStack {
                            Text("Enter value")
                            Spacer()
                            Stepper("", value: $goalValue, in: 1...100)
                                .labelsHidden()
                            Text("\(goalValue) times")
                                .foregroundStyle(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                    } else if goalUnit == .time {
                        Button(action: { showTimePicker.toggle() }) {
                            HStack {
                                Text("Enter value")
                                Spacer()
                                Text(formattedTime)
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.horizontal)
                    }
                    
                    // Unit
                    HStack {
                        Text("Unit")
                        Spacer()
                        Picker("", selection: $goalUnit) {
                            ForEach(GoalUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    
                    // 🔴 Custom Unit
                    if goalUnit == .custom {
                        HStack {
                            Text("Enter custom unit")
                            Spacer()
                            TextField("e.g., km, pages", text: $customUnit)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                    }
                }
                
                // Color Picker
                ColorPickerView(selectedColor: $selectedColor)
                
                // Repeat
                HStack {
                    Text("Repeat")
                        .font(.headline)
                    Spacer()
                    Picker("", selection: $repeatOption) {
                        Text("Every day").tag(RepeatOption.daily)
                        Text("Every week").tag(RepeatOption.weekly)
                        Text("Every month").tag(RepeatOption.monthly)
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
                
                // Weekday selection
                if repeatOption == .weekly {
                    WeekdaySelector(selectedDays: $selectedDays)
                        .padding(.horizontal)
                }
                
                if repeatOption == .monthly {
                    MonthDaySelector(selectedDays: $selectedMonthDays)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle(habitToEdit == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { saveHabit() }
                        .bold()
                        .disabled(!isDoneButtonEnabled)
                }
            }
            .onAppear {
                if let habit = habitToEdit {
                    habitName = habit.title ?? ""
                    selectedEmoji = habit.icon ?? ""
                    selectedColor = Color(hex: habit.color ?? "")
                    repeatOption = RepeatOption(rawValue: habit.repeatOption ?? "daily") ?? .daily
                    selectedDays = Set((habit.days).compactMap { Weekday(rawValue: $0 as! String) })
                    goalValue = Int(habit.goal)
                }
            }
        }
    }

    
    private func saveHabit() {
        guard !habitName.isEmpty else { return }

        let goal: Double = goalUnit == .time ? timeGoal / 60 : Double(goalValue)
        let unitString = goalUnit == .custom ? customUnit : goalUnit.rawValue
        let colorHex = selectedColor?.toHex() ?? ""
        let daysArray = selectedDays.map { $0.rawValue }

        if let habit = habitToEdit {
            habitViewModel.updateHabit(
                habit,
                title: habitName,
                icon: selectedEmoji,
                color: colorHex,
                goal: goal,
                repeatOption: repeatOption.rawValue,
                days: daysArray
            )
        } else {
            habitViewModel.addHabit(
                title: habitName,
                icon: selectedEmoji,
                color: colorHex,
                goal: goal,
                repeatOption: repeatOption.rawValue,
                days: daysArray
            )
        }
        dismiss()
    }
}
