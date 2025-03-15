import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    
    var body: some View {
        NavigationStack {
            VStack {
                // title + calendar + profile
                HStack {
                    Button(action: { /* open profile */ }) {
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("Today")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: { /* open calendar */ }) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal)
                
                // list of habits
                List {
                    ForEach(habits) { habit in
                        HabitRowView(habit: habit)
                    }
                }
                .listStyle(.plain)
                
                // add button
                FloatingAddButton(action: { /* add habit */ })
            }
            .padding()
        }
    }
}
    #Preview {
        TodayView()
    }
