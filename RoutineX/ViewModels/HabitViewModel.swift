import SwiftUI
import CoreData

class HabitViewModel: ObservableObject {
    @Published var habits: [HabitEntity] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchHabits(for: Date())
    }
    
    func fetchHabits(for date: Date) {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HabitEntity.createdAt, ascending: false)]
        
        do {
            let allHabits = try context.fetch(request)
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: date)
            
            habits = allHabits.filter { habit in
                guard let repeatOption = habit.repeatOption else { return false }
                
                switch repeatOption {
                case "daily":
                    return true
                case "weekly":
                    return (habit.days as? [String])?.contains(calendar.weekdaySymbols[weekday - 1]) ?? false
                case "monthly":
                    return calendar.component(.day, from: habit.createdAt ?? Date()) == calendar.component(.day, from: date)
                default:
                    return false
                }
            }
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
        newHabit.days = days as NSArray
        newHabit.completionHistory = []
        
        saveContext()
        fetchHabits(for: Date())
        
    }
    
    func updateHabit(_ habit: HabitEntity, title: String, icon: String, color: String, goal: Double, repeatOption: String, days: [String]) {
        habit.title = title
        habit.icon = icon
        habit.color = color
        habit.goal = goal
        habit.repeatOption = repeatOption
        habit.days = days as NSArray
        
        saveContext()
        fetchHabits(for: Date())
    }
    
    func deleteHabit(_ habit: HabitEntity) {
        context.delete(habit)
        saveContext()
        fetchHabits(for: Date())
    }
    
    func addProgress(to habit: HabitEntity, value: Double) {
        habit.progressValue += value
        if habit.progressValue >= habit.goal {
            habit.progressValue = habit.goal
        }
        
        saveContext()
        fetchHabits(for: Date())
    }
    
    func toggleHabitCompletion(_ habit: HabitEntity) {
        let today = Calendar.current.startOfDay(for: Date())
        
        var updatedCompletionHistory = (habit.completionHistory as? [Date]) ?? []
        
        if updatedCompletionHistory.contains(today) {
            updatedCompletionHistory = updatedCompletionHistory.filter { $0 != today }
        } else {
            updatedCompletionHistory.append(today)
        }
        
        habit.completionHistory = updatedCompletionHistory as NSArray
        habit.progress = habit.progress + 1
        
        saveContext()
        fetchHabits(for: Date())
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving Core Data: \(error)")
        }
    }
}
