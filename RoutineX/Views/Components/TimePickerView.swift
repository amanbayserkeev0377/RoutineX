import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: TimeInterval
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("", selection: Binding(get: {
                    timeToDate()
                }, set: { newDate in
                    selectedTime = dateToTimeInterval(newDate)
                }), displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .onAppear {
                    if selectedTime == 0 {
                        selectedTime = 0
                    }
                }
                Spacer()
            }
            .navigationTitle("Select Time")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func timeToDate() -> Date {
        let calendar = Calendar.current
        let components = DateComponents(hour: Int(selectedTime) / 3600, minute: (Int(selectedTime) % 3600) / 60)
        return calendar.date(from: components) ?? Date()
    }
    
    private func dateToTimeInterval(_ date: Date) -> TimeInterval {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let timeInterval = TimeInterval((components.hour ?? 0) * 3600 + (components.minute ?? 0) * 60)
        return max(timeInterval, 0)
    }
}
