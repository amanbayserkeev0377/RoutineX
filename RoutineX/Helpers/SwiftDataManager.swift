// SwiftDataManager.swift

import Foundation
import OSLog
import SwiftData

@MainActor
final class SwiftDataManager {
    // MARK: - Singleton
    static let shared = SwiftDataManager()
    
    // MARK: - Properties
    let modelContainer: ModelContainer
    let context: ModelContext
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.app.SwiftDataManager",
        category: "DataManager"
    )
    
    // MARK: - Initialization
    private init() {
        do {
            let schema = Schema([Habit.self, ActiveDayEntity.self, UnitEntity.self])
            let config = ModelConfiguration(schema: schema)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
            self.context = modelContainer.mainContext
        } catch {
            logger.error("Failed to initialize SwiftData: \(error.localizedDescription)")
            fatalError("SwiftData init failed: \(error.localizedDescription)")
        }
    }

    // Testing initializer
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.context = modelContainer.mainContext
    }
    
    // MARK: - Habit CRUD Operations
    
    func addHabit(with data: HabitUpdateData) {
        let newHabit = Habit(
            name: data.name,
            unit: data.unit,
            goalValue: data.goalValue,
            isCompleted: data.isCompleted,
            createdAt: data.createdAt,
            reminderTime: data.reminderTime,
            activeDays: data.activeDays
        )
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
    
    func updateHabit(_ habit: Habit, with data: HabitUpdateData) {
        habit.name = data.name
        habit.unit = data.unit
        habit.goalValue = data.goalValue
        habit.isCompleted = data.isCompleted
        habit.createdAt = data.createdAt
        habit.reminderTime = data.reminderTime
        habit.activeDays = data.activeDays
        saveContext()
    }
    
    func updateHabitDays(_ habit: Habit, activeDays: [ActiveDayEntity]) {
        habit.activeDays = activeDays
        saveContext()
    }
    
    func updateHabitReminder(_ habit: Habit, reminderTime: Date?) {
        habit.reminderTime = reminderTime
        saveContext()
    }
    
    // MARK: - Custom Units Management
    func fetchCustomUnits() -> [UnitEntity] {
        let fetchDescriptor = FetchDescriptor<UnitEntity>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            logger.error("Error fetching custom units: \(error.localizedDescription)")
            return []
        }
    }
    
    func addCustomUnit(_ name: String) {
        let newUnit = UnitEntity(name: name)
        context.insert(newUnit)
        saveContext()
    }
    
    func deleteCustomUnit(_ unit: UnitEntity) {
        context.delete(unit)
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
