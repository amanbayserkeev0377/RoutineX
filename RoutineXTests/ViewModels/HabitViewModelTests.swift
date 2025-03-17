import XCTest
@testable import RoutineX

@MainActor
final class HabitViewModelTests: XCTestCase {
    var viewModel: HabitViewModel!
    var testHabit: Habit!
    
    override func setUp() {
        super.setUp()
        viewModel = HabitViewModel()
        
        let activeDays = [ActiveDayEntity(day: "Mon"), ActiveDayEntity(day: "Wed")]
        
        testHabit = Habit(
            name: "Test Habit",
            unit: "count",
            goalValue: 10,
            isCompleted: false,
            createdAt: Date(),
            reminderTime: nil,
            activeDays: activeDays
        )
        
        let habitData = HabitUpdateData(
            name: testHabit.name,
            unit: testHabit.unit,
            goalValue: testHabit.goalValue,
            isCompleted: testHabit.isCompleted,
            createdAt: testHabit.createdAt,
            reminderTime: testHabit.reminderTime,
            activeDays: activeDays
        )

        SwiftDataManager.shared.addHabit(with: habitData)
        
        viewModel.loadHabits()
    }
    
    override func tearDown() {
        for habit in viewModel.habits {
            SwiftDataManager.shared.deleteHabit(habit)
        }
        viewModel = nil
        super.tearDown()
    }
    
    func testAddHabit() {
        let initialCount = viewModel.habits.count
        let newActiveDays = [ActiveDayEntity(day: "Mon"), ActiveDayEntity(day: "Fri")]

        let habitData = HabitUpdateData(
            name: "New Habit",
            unit: "min",
            goalValue: 20,
            isCompleted: false,
            createdAt: Date(),
            reminderTime: nil,
            activeDays: newActiveDays
        )

        viewModel.addHabit(with: habitData)

        XCTAssertEqual(viewModel.habits.count, initialCount + 1, "Habit count should increase after adding a habit")
        XCTAssertTrue(viewModel.habits.contains { $0.name == "New Habit" }, "Newly added habit should exist")
    }
    
    func testUpdateHabit() {
        guard let habitToUpdate = viewModel.habits.first else {
            XCTFail("No habits found to update")
            return
        }
        
        let updatedActiveDays = [ActiveDayEntity(day: "Tue"), ActiveDayEntity(day: "Thu")]
        
        let updateData = HabitUpdateData(
            name: "Updated Habit",
            unit: "steps",
            goalValue: 15,
            isCompleted: habitToUpdate.isCompleted,
            createdAt: habitToUpdate.createdAt,
            reminderTime: habitToUpdate.reminderTime,
            activeDays: updatedActiveDays
        )

        viewModel.updateHabit(habitToUpdate, with: updateData)
        
        XCTAssertEqual(habitToUpdate.name, "Updated Habit", "Habit name should be updated")
        XCTAssertEqual(habitToUpdate.unit, "steps", "Habit unit should be updated")
        XCTAssertEqual(habitToUpdate.goalValue, 15, "Habit goal value should be updated")
        XCTAssertEqual(
            habitToUpdate.activeDays.map { $0.day }.sorted(),
            updatedActiveDays.map { $0.day }.sorted(),
            "Habit active days should be updated"
        )
    }
    
    func testDeleteHabit() {
        guard let habitToDelete = viewModel.habits.first else {
            XCTFail("No habits found to delete")
            return
        }
        
        let initialCount = viewModel.habits.count
        viewModel.deleteHabit(habitToDelete)
        
        XCTAssertEqual(viewModel.habits.count, initialCount - 1, "Habit count should decrease after deletion")
        XCTAssertFalse(viewModel.habits.contains(where: { $0.id == habitToDelete.id }), "Deleted habit should not exist")
    }
    
    func testLoadHabits() {
        let initialHabits = viewModel.habits
        viewModel.loadHabits()
        XCTAssertEqual(viewModel.habits, initialHabits, "Habits should be correctly loaded from SwiftData")
    }
}
