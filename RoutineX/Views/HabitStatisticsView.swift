import SwiftUI
import FSCalendar

struct HabitStatisticsView: View {
    let habit: HabitEntity
    @Environment(\.dismiss) private var dismiss
    @State private var completedDates: Set<Date> = []
    @State private var showEditHabitView = false
    
    private var currentStreak: Int {
        calculateStreak(dates: completedDates)
    }
    
    private var bestStreak: Int {
        calculateBestStreak(dates: completedDates)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CalendarView(selectedDates: $completedDates)
                    .frame(height: 350)
                    .padding()
                
                VStack(spacing: 12) {
                    streakView(title: "Current Streak", count: currentStreak)
                    streakView(title: "Best streak", count: bestStreak)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle(habit.title ?? "Habit")
            navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") { dismiss() }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Edit") { showEditHabitView = true }
                    }
                }
                .onAppear {
                    loadCompletedDates()
                }
                .sheet(isPresented: $showEditHabitView) {
                    NewHabitView(habitToEdit: habit)
                }
        }
    }
    
    private func loadCompletedDates() {
        if let dates = habit.completionHistory as? [Date] {
            completedDates = Set(dates)
        }
    }
    
    private func streakView(title: String, count: Int) -> some View {
        VStack {
            Text(title)
                .font(.headline)
            Text("\(count)")
                .font(.largeTitle.bold())
                .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CalendarView: UIViewRepresentable {
    @Binding var selectedDates: Set<Date>
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.allowsMultipleSelection = true
        calendar.delegate = context.coordinator
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDates.insert(date)
        }
        
        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDates.remove(date)
        }
    }
}

private func calculateStreak(dates: Set<Date>) -> Int {
    let sortedDates = dates.sorted(by: >)
    guard let latestDate = sortedDates.first else { return 0 }
    
    var streak = 1
    var previousDate = latestDate
    let calendar = Calendar.current
    
    for date in sortedDates.dropFirst() {
        if let nextDate = calendar.date(byAdding: .day, value: -1, to: previousDate), nextDate == date {
            streak += 1
            previousDate = date
        } else {
            break
        }
    }
    return streak
}

private func calculateBestStreak(dates: Set<Date>) -> Int {
    let sortedDates = dates.sorted()
    var bestStreak = 0
    var currentStreak = 0
    let calendar = Calendar.current
    var previousDate: Date?
    
    for date in sortedDates {
        if let prev = previousDate, let nextDate = calendar.date(byAdding: .day, value: 1, to: prev), nextDate == date {
        } else {
            bestStreak = max(bestStreak, currentStreak)
            currentStreak = 1
        }
        previousDate = date
    }
    return max(bestStreak, currentStreak)
}
