import SwiftUI

struct HabitRowView: View {
    let habit: HabitEntity
    let habitViewModel: HabitViewModel
    
    @State private var isCompleted: Bool = false
    @State private var showProgressInput = false
    @State private var enteredProgress: String = ""
    
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

                Text("Completed: \(habit.progressValue, specifier: "%.1f") \(habit.goal > 0 ? "/ \(habit.goal)" : "")")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()

            Button(action: {
                showProgressInput = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.title2)
            }
            .padding(.trailing, 10)
        }
        .padding(.vertical, 4)
        .onAppear {
            isCompleted = isHabitCompletedToday()
        }
        .swipeActions(edge: .leading) {
            Button {
                showProgressInput = true
            } label: {
                Label("Add Progress", systemImage: "plus")
            }
            .tint(.blue)
        }
        .sheet(isPresented: $showProgressInput) {
            ProgressInputView(habit: habit, habitViewModel: habitViewModel, isPresented: $showProgressInput)
        }
    }
    
    private func isHabitCompletedToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let completedDates = (habit.completionHistory as? [Date]) ?? []
        return completedDates.contains(today)
    }
}
