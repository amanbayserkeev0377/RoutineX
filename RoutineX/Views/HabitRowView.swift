import SwiftUI

struct HabitRowView: View {
    let habit: HabitEntity
    let habitViewModel: HabitViewModel
    
    @State private var isCompleted: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                let title = habit.title ?? "Untitled Habit"
                let icon = (habit.icon?.isEmpty == false) ? habit.icon! : nil

                HStack {
                    if let icon = icon {
                        Text(icon)
                            .font(.title2)
                    }
                    Text(title)
                        .font(.headline)
                }

                Text(isCompleted ? "Completed today" : "Not completed today")
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
            .padding(.trailing, 10)
        }
        .padding(.vertical, 4)
        .onAppear {
            isCompleted = isHabitCompletedToday()
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                habitViewModel.deleteHabit(habit)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                withAnimation {
                    habitViewModel.toggleHabitCompletion(habit)
                    isCompleted.toggle()
                }
            } label: {
                Label(isCompleted ? "Undo" : "Complete", systemImage: isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle")
            }
            .tint(isCompleted ? .gray : .green)
        }
    }
    
    private func isHabitCompletedToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let completedDates = (habit.completionHistory as? [Date]) ?? []
        return completedDates.contains(today)
    }
}
