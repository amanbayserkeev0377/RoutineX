//
//  HabitViewModel.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI
import FirebaseFirestore
import Combine

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchHabits()
    }
    
    func fetchHabits() {
        db.collection("habits")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching habits: \(error)")
                    return
                }
                self.habits = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Habit.self)
                } ?? []
            }
    }
    
    func addHabit(title: String, icon: String, color: String, goal: Double) {
        let newHabit = Habit(
            title: title,
            icon: icon,
            color: color,
            goal: goal,
            progress: 0,
            createdAt: Date()
        )
        
        do {
            _ = try db.collection("habits").addDocument(from: newHabit)
        } catch {
            print("Error adding habit: \(error)")
        }
    }
    
    func toggleHabitCompletion(_ habit: Habit) {
        guard let habitID = habit.id else { return }
        
        let newProgress = habit.progress >= habit.goal ? 0 : habit.progress + 1
        
        db.collection("habits").document(habitID).updateData([
            "progress": newProgress
        ]) { error in
            if let error = error {
                print("Error updating habit: \(error)")
            } else {
                DispatchQueue.main.async {
                    if let index = self.habits.firstIndex(where: { $0.id == habitID }) {
                        self.habits[index].progress = newProgress
                    }
                }
            }
        }
    }
}
