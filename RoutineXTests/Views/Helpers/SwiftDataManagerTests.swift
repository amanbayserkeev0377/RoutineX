import XCTest
import SwiftData
@testable import RoutineX

@MainActor
final class SwiftDataManagerTests: XCTestCase {

    var manager: SwiftDataManager!
    var container: ModelContainer!

    override func setUp() async throws {
        try await super.setUp()

        let schema = Schema([Habit.self])
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
        manager.addHabit(name: "Test Habit", unit: "count", goalValue: 10)
        let updatedCount = manager.fetchHabits().count
        XCTAssertEqual(updatedCount, initialCount + 1, "Habit was not added correctly")
    }

    func testDeleteHabit() async throws {
        manager.addHabit(name: "Test Habit", unit: "count", goalValue: 10)

        let allHabits = manager.fetchHabits()
        guard let addedHabit = allHabits.first(where: { $0.name == "Test Habit" }) else {
            XCTFail("Habit not found after adding")
            return
        }

        let habitID = addedHabit.createdAt

        manager.deleteHabit(addedHabit)
        let newHabits = manager.fetchHabits()
        XCTAssertNil(newHabits.first(where: { $0.createdAt == habitID }), "Habit was not deleted correctly")
    }

    func testUpdateHabit() async throws {
        manager.addHabit(name: "Original Name", unit: "count", goalValue: 10)

        let habits = manager.fetchHabits()
        guard let habit = habits.first(where: { $0.name == "Original Name" }) else {
            XCTFail("Habit not found after adding")
            return
        }

        manager.updateHabit(habit, name: "Updated Name", unit: "reps", goalValue: 20, isCompleted: true)

        let updatedHabits = manager.fetchHabits()
        guard let updatedHabit = updatedHabits.first(where: { $0.id == habit.id }) else {
            XCTFail("Updated habit not found")
            return
        }

        XCTAssertEqual(updatedHabit.name, "Updated Name")
        XCTAssertEqual(updatedHabit.unit, "reps")
        XCTAssertEqual(updatedHabit.goalValue, 20)
        XCTAssertTrue(updatedHabit.isCompleted)
    }
}
