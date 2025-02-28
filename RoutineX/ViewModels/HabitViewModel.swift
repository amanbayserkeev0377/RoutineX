//
//  HabitViewModel.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI
import CoreData

class HabitViewModel: ObservableObject {
    @Published var habits: [HabitEntity] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchHabits()
    }
    
    func fetchHabits() {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HabitEntity.createdAt, ascending: false)]
        
        do {
            habits = try context.fetch(request)
        } catch {
            print("Error fetching habits: \(error)")
        }
    }
    
    func addHabit(title: String, icon: String, color: String, goal: Double, repeatOption: String, days: [String] = []) {
        let newHabit = HabitEntity(context: context)
        newHabit.id = UUID()
        newHabit.title = title
        newHabit.icon = icon
        newHabit.color = color
        newHabit.goal = goal
        newHabit.progress = 0
        newHabit.createdAt = Date()
        newHabit.repeatOption = repeatOption
        newHabit.days = days as NSObject
        newHabit.completionHistory = [] as NSObject
        
        saveContext()
        fetchHabits()
        
    }
    
    func deleteHabit(_ habit: HabitEntity) {
        context.delete(habit)
        saveContext()
        fetchHabits()
    }
    
    func toggleHabitCompletion(_ habit: HabitEntity) {
        let today = Calendar.current.startOfDay(for: Date())
        
        var updatedCompletionHistory = (habit.completionHistory as? [Date]) ?? []
        
        if updatedCompletionHistory.contains(today) {
            updatedCompletionHistory.removeAll { $0 == today }
        } else {
            updatedCompletionHistory.append(today)
        }
        
        habit.completionHistory = updatedCompletionHistory as NSObject
        habit.progress = habit.progress + 1
        
        saveContext()
        fetchHabits()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving Core Data: \(error)")
        }
    }
}
