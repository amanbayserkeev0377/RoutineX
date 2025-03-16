import SwiftData
import Foundation
import OSLog

@MainActor
final class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    let modelContainer: ModelContainer
    let context: ModelContext
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.app.SwiftDataManager",
                                category: "DataManager")
    
    private init() {
        do {
            let config = ModelConfiguration(for: Habit.self)
            self.modelContainer = try ModelContainer(for: Habit.self, configurations: config)
            self.context = modelContainer.mainContext
        } catch {
            logger.error("Failed to initialize SwiftData: \(error.localizedDescription)")
#if DEBUG
            fatalError("SwiftData init failed: \(error.localizedDescription)")
#endif
        }
    }
    
    // MARK: - CRUD Operations
    
    func addHabit(name: String, unit: String, goalValue: Int, isCompleted: Bool = false, createdAt: Date = Date()) {
        let newHabit = Habit(
            name: name,
            unit: unit,
            goalValue: goalValue,
            isCompleted: isCompleted,
            createdAt: createdAt)
        context.insert(newHabit)
        saveContext()
    }
    
    func deleteHabit(_ habit: Habit) {
        context.delete(habit)
        saveContext()
    }
    
    func fetchHabits() -> [Habit] {
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        do {
            return try context.fetch(descriptor)
        } catch {
            logger.error("Failed to fetch habits: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateHabit(_ habit: Habit, name: String, unit: String, goalValue: Int, isCompleted: Bool) {
        habit.name = name
        habit.unit = unit
        habit.goalValue = goalValue
        habit.isCompleted = isCompleted
        saveContext()
    }
    
    // MARK: - Helper Methods
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            logger.error("Context save error: \(error.localizedDescription)")
        }
    }
}
