// TimePickerView.swift

import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Done")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.black)
            })
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
        .presentationDetents([.medium])
    }
}

#Preview {
    TimePickerView(selectedTime: .constant(Date()))
}
