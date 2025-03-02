import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: TimeInterval
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("", selection: Binding(get: {
                    Date(timeIntervalSince1970: selectedTime)
                }, set: { newDate in
                    selectedTime = newDate.timeIntervalSince1970
                }), displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                
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
}
