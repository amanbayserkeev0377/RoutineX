import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a,r, g , b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "000000"
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
}

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var habitViewModel: HabitViewModel
    
    var habitToEdit: HabitEntity?
    
    @State private var habitName: String = ""
    @State private var selectedEmoji: String = ""
    @State private var selectedColor: Color? = nil
    @State private var customColor: Color = .black
    @State private var repeatOption: RepeatOption = .daily
    @State private var selectedDays: Set<Weekday> = []
    @State private var selectedMonthDays: Set<Int> = []
    
    @State private var goalValue: String = ""
    @State private var goalUnit: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    let colors: [Color] = [.red, .yellow, .orange, .green, .blue, .purple, .pink, .gray]
    
    var isDoneButtonEnabled: Bool {
        return !habitName.isEmpty
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
                
                // TextField
                TextField("Habit Name", text: $habitName)
                    .font(.title2.weight(.semibold))
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .focused($isTextFieldFocused)
                    .onSubmit { isTextFieldFocused = false }
                
                // Goal Value
                HStack {
                    TextField("Goal Value", text: $goalValue)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Unit (e.g., min, km, times", text: $goalUnit)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Color Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(colors, id: \ .self) { color in
                            colorCircle(color)
                        }
                        customColorCircle()
                    }
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
                }
            }
        }
    }
    
    
    private func colorCircle(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
            )
            .onTapGesture {
                selectedColor = color
            }
    }
    
    
    private func customColorCircle() -> some View {
        return ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
            Circle()
                .fill(customColor)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
            ColorPicker("", selection: $customColor, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 32, height: 32)
                .background(Color.clear)
        }
        .contentShape(Circle())
        .onAppear {
            if customColor == .black {
                customColor = .clear
            }
        }
        .onChange(of: customColor) {
            selectedColor = customColor
        }
    }





    
    private func saveHabit() {
        if let habit = habitToEdit {
            habit.title = habitName
            habit.icon = selectedEmoji
            habit.color = selectedColor?.toHex() ?? ""
            habit.repeatOption = repeatOption.rawValue
            habit.days = selectedDays.map { $0.rawValue } as NSArray
        } else {
            habitViewModel.addHabit(
                title: habitName,
                icon: selectedEmoji,
                color: selectedColor?.toHex() ?? "",
                goal: Double(goalValue) ?? 1,
                repeatOption: repeatOption.rawValue,
                days: selectedDays.map { $0.rawValue }
            )
        }
        dismiss()
    }
    
    
    private func colorToHex(_ color: Color) -> String {
        switch color {
        case .red: return "FF3B30"
        case .yellow: return "FFCC00"
        case .orange: return "FF9500"
        case .green: return "34C759"
        case .blue: return "007AFF"
        case .purple: return "AF52DE"
        case .pink: return "FF2D55"
        case .gray: return "8E8E93"
        case .brown: return "964B00"
        default: return "007AFF"
        }
    }
}
