import Foundation
import OSLog
import SwiftData

@MainActor
final class SwiftDataManager {
    static let shared = SwiftDataManager()
    
    let modelContainer: ModelContainer
    let context: ModelContext
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.app.SwiftDataManager",
        category: "DataManager"
    )
    
    private init() {
        let fileManager = FileManager.default
        if let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let databaseURL = appSupport.appendingPathComponent("default.store")
            
            if !fileManager.fileExists(atPath: databaseURL.path) {
                try? fileManager.createDirectory(at: appSupport, withIntermediateDirectories: true)
            }
        }

        do {
            let schema = Schema([Habit.self])
            let config = ModelConfiguration(schema: schema)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
            self.context = modelContainer.mainContext
        } catch {
            logger.error("Failed to initialize SwiftData: \(error.localizedDescription)")
            fatalError("SwiftData init failed: \(error.localizedDescription)")
        }
    }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.context = modelContainer.mainContext
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
    
    func updateHabitDays(_ habit: Habit, activeDays: [String]) {
        habit.activeDays = activeDays
        saveContext()
    }
    
    func updateHabitReminder(_ habit: Habit, reminderTime: Date?) {
        habit.reminderTime = reminderTime
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
