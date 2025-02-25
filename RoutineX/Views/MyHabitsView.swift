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

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: selectedDate)
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
                        ForEach(habitViewModel.habits) { habit in
                            HabitCardView(habit: habit)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }

            if showDatePicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDatePicker = false
                    }

                VStack {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .frame(height: 400)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .padding(.horizontal, 20)

                    Button("Done") {
                        showDatePicker = false
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: showDatePicker)
    }
}


// 🔹 Кастомная карточка привычки
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


