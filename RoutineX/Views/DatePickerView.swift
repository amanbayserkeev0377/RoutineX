//
//  DatePickerView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI
import UIKit

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: {
                    selectedDate = Date()
                }) {
                    Text("Today")
                        .font(.headline)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                Text("Select Date")
                    .font(.headline)
                    .bold()
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12) // Поднимаем заголовок чуть выше
            .padding(.bottom, 5) // Добавляем отступ снизу, чтобы текст не сжимался

            CalendarViewRepresentable(selectedDate: $selectedDate)
                .frame(minHeight: 500, maxHeight: .infinity)
            
        }
        .presentationDetents([.fraction(0.7)])
        .presentationDragIndicator(.visible)
    }
}

struct CalendarViewRepresentable: UIViewControllerRepresentable {
    @Binding var selectedDate: Date
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let calendarView = UICalendarView()
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(calendarView)
        viewController.view.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarViewRepresentable

        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents else { return }
            let calendar = Calendar.current
            if let date = calendar.date(from: dateComponents) {
                DispatchQueue.main.async {
                    self.parent.selectedDate = date
                }
            }
        }
    }
}
