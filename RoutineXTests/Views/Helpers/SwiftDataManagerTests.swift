import XCTest
import SwiftData
@testable import RoutineX

@MainActor
final class SwiftDataManagerTests: XCTestCase {

    var manager: SwiftDataManager!
    var container: ModelContainer!

    override func setUp() async throws {
        try await super.setUp()

        let schema = Schema([Habit.self, ActiveDayEntity.self, UnitEntity.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [config])
        manager = SwiftDataManager(modelContainer: container)
    }

    override func tearDown() async throws {
        try await clearDatabase()
        manager = nil
        container = nil
        try await super.tearDown()
    }

    private func clearDatabase() async throws {
        let descriptor = FetchDescriptor<Habit>()
        let habits = try container.mainContext.fetch(descriptor)
        for habit in habits {
            container.mainContext.delete(habit)
        }
        try container.mainContext.save()
    }

    func testAddHabit() async throws {
        let initialCount = manager.fetchHabits().count
        let habitData = HabitUpdateData(
            name: "Test Habit",
            unit: "count",
            goalValue: 10,
            isCompleted: false,
            createdAt: Date(),
            reminderTime: nil,
            activeDays: []
        )
        manager.addHabit(with: habitData)
        let updatedCount = manager.fetchHabits().count
        XCTAssertEqual(updatedCount, initialCount + 1, "Habit was not added correctly")
    }

    func testDeleteHabit() async throws {
        let habitData = HabitUpdateData(
            name: "Test Habit",
            unit: "count",
            goalValue: 10,
            isCompleted: false,
            createdAt: Date(),
            reminderTime: nil,
            activeDays: []
        )
        manager.addHabit(with: habitData)

        let allHabits = manager.fetchHabits()
        guard let addedHabit = allHabits.first(where: { $0.name == "Test Habit" }) else {
            XCTFail("Habit not found after adding")
            return
        }

        let habitID = addedHabit.id

        manager.deleteHabit(addedHabit)
        let newHabits = manager.fetchHabits()
        XCTAssertNil(newHabits.first(where: { $0.id == habitID }), "Habit was not deleted correctly")
    }

    func testUpdateHabit() async throws {
        let habitData = HabitUpdateData(
            name: "Original Name",
            unit: "count",
            goalValue: 10,
            isCompleted: false,
            createdAt: Date(),
            reminderTime: nil,
            activeDays: []
        )

        manager.addHabit(with: habitData)

        try await Task.sleep(nanoseconds: UInt64(0.3 * Double(NSEC_PER_SEC)))

        var habits = manager.fetchHabits()
        guard let habit = habits.first(where: { $0.name == "Original Name" }) else {
            XCTFail("Habit not found after adding")
            return
        }

        let newReminderTime = Date().addingTimeInterval(3600)
        let newActiveDays = [ActiveDayEntity(day: "Mon"), ActiveDayEntity(day: "Wed")]

        let updatedData = HabitUpdateData(
            name: "Updated Name",
            unit: "reps",
            goalValue: 20,
            isCompleted: true,
            createdAt: habit.createdAt,
            reminderTime: newReminderTime,
            activeDays: newActiveDays
        )

        manager.updateHabit(habit, with: updatedData)

        try await Task.sleep(nanoseconds: UInt64(0.3 * Double(NSEC_PER_SEC)))

        habits = manager.fetchHabits()
        guard let updatedHabit = habits.first(where: { $0.id == habit.id }) else {
            XCTFail("Updated habit not found")
            return
        }

        XCTAssertEqual(updatedHabit.name, "Updated Name")
        XCTAssertEqual(updatedHabit.unit, "reps")
        XCTAssertEqual(updatedHabit.goalValue, 20)
        XCTAssertTrue(updatedHabit.isCompleted)
        XCTAssertEqual(updatedHabit.reminderTime, newReminderTime)
        XCTAssertEqual(updatedHabit.activeDays.map { $0.day }.sorted(), ["Mon", "Wed"].sorted())
    }

    func testUpdateHabitDays() async throws {
        let habitData = HabitUpdateData(
            name: "Test Habit",
            unit: "count",
            goalValue: 10,
            isCompleted: false,
            createdAt: Date(),
            reminderTime: nil,
            activeDays: []
        )

        manager.addHabit(with: habitData)

        try await Task.sleep(nanoseconds: UInt64(0.3 * Double(NSEC_PER_SEC)))

        var habits = manager.fetchHabits()
        guard let habit = habits.first(where: { $0.name == "Test Habit" }) else {
            XCTFail("Habit not found after adding")
            return
        }

        let newActiveDays = ["Tue", "Thu"].map { ActiveDayEntity(day: $0) }
        manager.updateHabitDays(habit, activeDays: newActiveDays)

        try await Task.sleep(nanoseconds: UInt64(0.3 * Double(NSEC_PER_SEC)))

        habits = manager.fetchHabits()
        guard let updatedHabit = habits.first(where: { $0.id == habit.id }) else {
            XCTFail("Updated habit not found")
            return
        }

        XCTAssertEqual(
            updatedHabit.activeDays.map { $0.day }.sorted(),
            ["Tue", "Thu"].sorted()
        )
    }
}
