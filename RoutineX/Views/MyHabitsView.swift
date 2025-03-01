import SwiftUI

struct MyHabitsView: View {
    @EnvironmentObject var habitViewModel: HabitViewModel
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showNewHabitView = false
    @State private var showSettings = false
    @State private var selectedFilter: HabitFilter = .all
    
    enum HabitFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: selectedDate)
    }
    
    var filteredHabits: [HabitEntity] {
        switch selectedFilter {
        case .all:
            return habitViewModel.habits
        case .active:
            return habitViewModel.habits.filter { $0.progress < $0.goal }
        case .completed:
            return habitViewModel.habits.filter { $0.progress >= $0.goal }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(HabitFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    List {
                        ForEach(habitViewModel.habits.compactMap { $0.id }, id: \.self) { id in
                            if let habit = habitViewModel.habits.first(where: { $0.id == id }) {
                                HabitRowView(habit: habit, habitViewModel: habitViewModel)
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

// MARK: - HabitRowView
struct HabitRowView: View {
    let habit: HabitEntity
    let habitViewModel: HabitViewModel
    
    @State private var isCompleted: Bool = false
    
    var body: some View {
        HStack {
            Text(habit.icon ?? "⬜")
                .font(.title2)
            
            VStack(alignment: .leading) {
                let title = habit.title ?? "Untitled Habit"
                let progressText = "\(Int(habit.progress))/\(Int(habit.goal)) completed"
                
                Text(title)
                    .font(.headline)
                Text(progressText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    habitViewModel.toggleHabitCompletion(habit)
                    isCompleted.toggle()
                }
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isCompleted ? .green : .gray)
                    .font(.title2)
                    .scaleEffect(isCompleted ? 1.2 : 1.0)
                    .animation(.spring(), value: isCompleted)
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            isCompleted = habit.progress >= habit.goal
        }
    }
}
