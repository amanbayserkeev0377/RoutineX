import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                Text("\(habit.goalValue) \(habit.unit)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            
            Button(action: { /* mark as completed */ }) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isCompleted ? .green : .gray)
                    .font(.title2)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HabitRowView(habit: Habit(name: "Brush Teeth", unit: "count", goalValue: 2, isCompleted: false, createdAt: Date()))
}
