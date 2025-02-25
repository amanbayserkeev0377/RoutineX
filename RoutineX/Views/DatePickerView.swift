//
//  DatePickerView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .padding()
            }
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .frame(maxHeight: 450)
                .padding()
                .onChange(of: selectedDate) { _, _ in
                    dismiss()
                }
        }
        .padding(.bottom, 20)
    }
}
