import SwiftUI

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var habitViewModel: HabitViewModel
    
    @State private var habitName: String = ""
    @State private var selectedEmoji: String = ""
    @State private var selectedColor: Color? = nil
    @State private var customColor: Color = .black
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
                
                // Choose color
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
                        Text("Custom").tag(RepeatOption.custom)
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
                
                // Weekday selection
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
        let isSelected = selectedColor == customColor
        let borderColor: Color = isSelected ? .white : .clear

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
