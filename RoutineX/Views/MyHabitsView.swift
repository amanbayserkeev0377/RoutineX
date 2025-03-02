import SwiftUI

struct MyHabitsView: View {
    @EnvironmentObject var habitViewModel: HabitViewModel
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showNewHabitView = false
    @State private var showSettings = false
    @State private var selectedHabit: HabitEntity?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(habitViewModel.habits.compactMap { $0.id }, id: \.self) { id in
                            if let habit = habitViewModel.habits.first(where: { $0.id == id }) {
                                HabitRowView(habit: habit, habitViewModel: habitViewModel)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedHabit = habit
                                    }
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .onDelete(perform: deleteHabit)
                    }
                    .animation(.spring(), value: habitViewModel.habits)
                }
                .navigationTitle(formattedDate)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { showSettings.toggle() }) {
                            Image(systemName: "gearshape")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showDatePicker.toggle() }) {
                            Image(systemName: "calendar")
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showNewHabitView = true }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.blue)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .sheet(isPresented: $showNewHabitView) {
            NewHabitView()
        }
        .sheet(item: $selectedHabit) { habit in
            HabitStatisticsView(habit: habit)
        }
        .onDisappear {
            selectedHabit = nil
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        withAnimation {
            offsets.map { habitViewModel.habits[$0] }.forEach { habit in
                habitViewModel.deleteHabit(habit)
            }
        }
    }
}
