import SwiftUI

struct ActiveDaysView: View {
    @StateObject private var viewModel: ActiveDaysViewModel
    
    init(habit: Habit) {
        _viewModel = StateObject(wrappedValue: ActiveDaysViewModel(habit: habit))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            daySelectionGrid
        }
        .padding()
    }
    
    private var headerView: some View {
        HStack {
            Text("Active days")
                .font(.headline)
            Spacer()
            Button(action: {
                viewModel.toggleAllDays()
            }, label: {
                Text(viewModel.toggleButtonText)
                    .font(.caption2)
                    .foregroundStyle(.black)
            })
        }
    }
    
    private var daySelectionGrid: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.weekdays, id: \.self) { day in
                dayButton(for: day)
            }
        }
    }
    
    private func dayButton(for day: String) -> some View {
        let isSelected = viewModel.habit.activeDays.contains(day)
        
        return Button(action: {
            viewModel.toggleDaySelection(day)
        }, label: {
            Text(day)
                .frame(width: 45, height: 40)
                .background(isSelected ? Color.black : Color(.systemGray6))
                .foregroundStyle(isSelected ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.easeInOut, value: viewModel.habit.activeDays)
        })
    }
}

#Preview {
    ActiveDaysView(habit: Habit(
        name: "Workout",
        unit: "min",
        goalValue: 30,
        isCompleted: false,
        createdAt: Date(),
        activeDays: ["Mon", "Wed", "Fri"]
    ))
}
