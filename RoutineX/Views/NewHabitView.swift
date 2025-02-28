import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var habitViewModel: HabitViewModel

    @State private var habitName: String = ""
    @State private var selectedEmoji: String = ""
    @State private var selectedColor: Color? = nil
    @State private var repeatOption: RepeatOption = .daily
    @State private var selectedDays: Set<Weekday> = []
    @State private var completionHistory: [Date] = []
    
    @FocusState private var isTextFieldFocused: Bool

    let colors: [Color] = [.red, .yellow, .orange, .green, .blue, .purple, .pink, .gray]

    var isDoneButtonEnabled: Bool {
        return !habitName.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 🔥 Новый Emoji Picker без глобуса
                EmojiTextField(text: $selectedEmoji)
                    .frame(width: 80, height: 80)
                    .background((selectedColor ?? .gray).opacity(0.2))
                    .clipShape(Circle())
                    .padding(.top, 10)

                // Поле ввода (как в Reminders)
                TextField("Habit Name", text: $habitName)
                    .font(.title2.weight(.semibold))
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .focused($isTextFieldFocused)
                    .onSubmit { isTextFieldFocused = false }

                // Выбор цвета
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(colors, id: \ .self) { color in
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
                    }
                    .padding(.horizontal)
                }

                // 🔥 Секция "Repeat"
                HStack {
                    Text("Repeat")
                        .font(.headline)
                    Spacer()
                    Picker("", selection: $repeatOption) {
                        Text("Every day").tag(RepeatOption.daily)
                        Text("Every week").tag(RepeatOption.weekly)
                        Text("Every month").tag(RepeatOption.monthly)
                        Text("Custom").tag(RepeatOption.custom)
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)

                // Выбор дней недели (если выбран Custom)
                if repeatOption == .custom {
                    WeekdaySelector(selectedDays: $selectedDays)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("New Habit")
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
        }
    }

    private func saveHabit() {
        let hexColor = selectedColor.map { colorToHex($0) } ?? ""

        habitViewModel.addHabit(
            title: habitName,
            icon: selectedEmoji,
            color: hexColor,
            goal: 1,
            repeatOption: repeatOption.rawValue,
            days: repeatOption == .custom ? selectedDays.map { $0.rawValue } : []
        )
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
