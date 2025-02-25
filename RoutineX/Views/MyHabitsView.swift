//
//  MyHabitsView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct MyHabitsView: View {
    @EnvironmentObject var habitViewModel: HabitViewModel
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showNewHabitView = false

    var formattedDate: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: selectedDate)
        
        if selectedDay == today {
            return "Today"
        } else if selectedDay == calendar.date(byAdding: .day, value: -1, to: today) {
            return "Yesterday"
        } else if selectedDay == calendar.date(byAdding: .day, value: 1, to: today) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            return formatter.string(from: selectedDate)
        }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        // TODO: Переход в Settings
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Text(formattedDate)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: { showDatePicker.toggle() }) {
                        Image(systemName: "calendar")
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    LazyVStack(spacing: 15) {
                        if habitViewModel.habits.isEmpty {
                            Button(action: { showNewHabitView = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.blue)
                                    Text("Add new habit")
                                        .font(.headline)
                                        .foregroundStyle(.blue)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .padding()
                        } else {
                            ForEach(habitViewModel.habits) { habit in
                                HabitCardView(habit: habit)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
        }
        .animation(.easeInOut, value: showDatePicker)
        .sheet(isPresented: $showNewHabitView) {
            NewHabitView()
        }
    }
}

struct HabitCardView: View {
    var habit: Habit

    var body: some View {
        HStack {
            Text(habit.icon)
                .font(.largeTitle)
                .padding()
                .background(Color.white.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 15))

            VStack(alignment: .leading, spacing: 5) {
                Text(habit.title)
                    .font(.headline)
                Text("\(habit.progress)/\(habit.goal) completed")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(habit.progress >= habit.goal ? .green : .gray)
                .font(.title)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
    }
}


