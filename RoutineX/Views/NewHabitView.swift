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
    
    @State private var goalValue: Double = 1
    @State private var goalValueString: String = ""
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
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
                    .overlay(
                        Text(selectedEmoji.isEmpty ? "📚" : selectedEmoji)
                            .font(.system(size: 40))
                    )
                    .padding(.top, 10)
                
                // Habit name
                TextField("Habit Name", text: $habitName)
                    .font(.title2.weight(.semibold))
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                
                // Color Picker
                ColorPickerView(selectedColor: $selectedColor)
                
                // Goal Section
                VStack(spacing: 10) {
                    Text("Goal")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Enter Value (Count & Custom Unit)
                    if goalUnit == .count || goalUnit == .custom {
                        HStack {
                            Text("Enter value")
                            Spacer()
                            TextField("0", text: $goalValueString)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                            
                            if goalUnit == .count {
                                Stepper("", value: $goalValue, in: 1...100, step: 1, onEditingChanged: { _ in
                                    goalValueString = "\(Int(goalValue))"
                                })
                                .labelsHidden()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                    }
                    
                    // Time Picker
                    if goalUnit == .time {
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
                        .sheet(isPresented: $showTimePicker) {
                            TimePickerView(selectedTime: $timeGoal)
                                .presentationDetents([.medium])
                        }
                    }
                    
                    // Custom Unit
                    if goalUnit == .custom {
                        HStack {
                            Text("Enter custom unit")
                            Spacer()
                            TextField("km, pages", text: $customUnit)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                    }
                    
                    // Unit Picker
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
                }
                
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
                    goalValue = Double(habit.goal)
                }
                goalValueString = "\(Int(goalValue))"
            }
        }
    }
    
    
    private func saveHabit() {
        guard !habitName.isEmpty else { return }
        
        goalValue = Double(goalValueString.replacingOccurrences(of: ",", with: ".")) ?? 0
        let goal: Double = goalUnit == .time ? timeGoal / 60 : Double(goalValue)
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
