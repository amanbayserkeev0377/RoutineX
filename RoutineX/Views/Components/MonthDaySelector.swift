import SwiftUI

struct MonthDaySelector: View {
    @Binding var selectedDays: Set<Int>
    
    let days: [Int] = Array(1...31)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Days of the month")
                .font(.headline)
                .padding(.bottom, 5)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(days, id: \.self) { day in
                    Text("\(day)")
                        .frame(width: 36, height: 36)
                        .background(selectedDays.contains(day) ? Color.blue : Color(.systemGray5))
                        .clipShape(Circle())
                        .foregroundStyle(selectedDays.contains(day) ? .white : .black)
                        .onTapGesture {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
