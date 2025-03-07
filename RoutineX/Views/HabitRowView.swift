import SwiftUI

struct HabitRowView: View {
    let habit: HabitEntity
    let habitViewModel: HabitViewModel
    
    @State private var isCompleted: Bool = false
    
    var body: some View {
        HStack {
            if let icon = habit.icon, !icon.isEmpty {
                Text(icon)
                    .font(.title2)
                    .padding(10)
                    .background(Color(hex: habit.color ?? "007AFF"))
                    .clipShape(Circle())
            }
            
            Text(habit.title ?? "Untitled habit")
                .font(.headline)
            
            Spacer()
            
            Circle()
                .fill(isCompleted ? Color(hex: habit.color ?? "007AFF") : Color(.systemGray5))
                .frame(width: 24, height: 24)
                .onTapGesture {
                    habitViewModel.toggleHabitCompletion(habit)
                    isCompleted.toggle()
                }
        }
        .contentShape(Rectangle())
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
        .onAppear {
            isCompleted = isHabitCompletedToday()
        }
        .onChange(of: habit.completionHistory) {
            isCompleted = isHabitCompletedToday()
        }
    }
    
    
    private func isHabitCompletedToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let completedDates = (habit.completionHistory as? [Date]) ?? []
        return completedDates.contains(today)
    }
}
