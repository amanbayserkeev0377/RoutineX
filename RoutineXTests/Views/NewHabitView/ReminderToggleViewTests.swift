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
        habit.reminderTime = Date()
        
        await Task { @MainActor in
            do {
                try SwiftDataManager.shared.context.save()
            } catch {
                XCTFail("Saving context threw an error: \(error.localizedDescription)")
            }
        }.value
        
        // Assert
        XCTAssertNotNil(habit.reminderTime, "Reminder time should be set when toggle is enabled")
    }
    
    func testToggleReminderDisablesTime() {
        // Arrange
        let habit = Habit(name: "Test", unit: "count", goalValue: 1, isCompleted: false, createdAt: Date(), reminderTime: Date())
        context.insert(habit)
        
        // Act
        habit.reminderTime = nil
        try? context.save()
        
        // Assert
        XCTAssertNil(habit.reminderTime, "Reminder time should be nil when toggle is disabled")
    }
    
    func testChangingReminderTime() {
        // Arrange
        let habit = Habit(name: "Test", unit: "count", goalValue: 1, isCompleted: false, createdAt: Date(), reminderTime: Date())
        let newTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        context.insert(habit)
        
        // Act
        habit.reminderTime = newTime
        try? context.save()
        
        // Assert
        XCTAssertEqual(habit.reminderTime, newTime, "Reminder time should update correctly")
    }
}
