// ReminderToggleViewTests.swift

import XCTest
import SwiftData
@testable import RoutineX

final class ReminderToggleViewTests: XCTestCase {
    
    var container: ModelContainer!
    var context: ModelContext!
    
    @MainActor
    override func setUp() {
        super.setUp()
        let schema = Schema([Habit.self])
        container = try! ModelContainer(for: schema, configurations: [])
        context = ModelContext(container)
    }
    
    @MainActor
    override func tearDown() {
        container = nil
        context = nil
        super.tearDown()
    }
    
    func testToggleReminderEnablesTime() async {
        // Arrange
        let habit = Habit(name: "Test", unit: "count", goalValue: 1, isCompleted: false, createdAt: Date())
        context.insert(habit)
        
        // Act
        let newTime = Date()
        
        await MainActor.run {
            SwiftDataManager.shared.updateHabitReminder(habit, reminderTime: newTime)
        }
        
        await Task { @MainActor in
            do {
                try SwiftDataManager.shared.context.save()
            } catch {
                XCTFail("Saving context threw an error: \(error.localizedDescription)")
            }
        }.value
        
        // Assert
        XCTAssertNotNil(habit.reminderTime, "Reminder time should be set when toggle is enabled")
        XCTAssertEqual(habit.reminderTime, newTime, "Reminder time should be the newly set time")
    }
    
    func testToggleReminderDisablesTime() async {
        // Arrange
        let habit = Habit(name: "Test", unit: "count", goalValue: 1, isCompleted: false, createdAt: Date(), reminderTime: Date())
        context.insert(habit)
        
        // Act
        await MainActor.run {
            SwiftDataManager.shared.updateHabitReminder(habit, reminderTime: nil)
        }
        
        // Assert
        XCTAssertNil(habit.reminderTime, "Reminder time should be nil when toggle is disabled")
    }
    
    func testChangingReminderTime() async {
        // Arrange
        let habit = Habit(name: "Test", unit: "count", goalValue: 1, isCompleted: false, createdAt: Date(), reminderTime: Date())
        let newTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        context.insert(habit)
        
        // Act
        await MainActor.run {
            SwiftDataManager.shared.updateHabitReminder(habit, reminderTime: newTime)
        }
        
        // Assert
        XCTAssertEqual(habit.reminderTime, newTime, "Reminder time should update correctly")
    }
}
