import XCTest
@testable import RoutineX

@MainActor
final class ActiveDaysViewModelTests: XCTestCase {
    
    var habit: Habit!
    var viewModel: ActiveDaysViewModel!
    
    override func setUp() {
        super.setUp()
        habit = Habit(
            name: "Workout",
            unit: "min",
            goalValue: 30,
            isCompleted: false,
            createdAt: Date(),
            activeDays: []
        )
        viewModel = ActiveDaysViewModel(habit: habit)
    }
    
    override func tearDown() {
        habit = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testSelectingDayAddsToActiveDays() {
        // Arrange
        let day = "Mon"
        
        // Act
        viewModel.toggleDaySelection(day)
        
        // Assert
        XCTAssertTrue(habit.activeDays.contains(day), "Day should be added to activeDays")
    }
    
    func testDeselectingDayRemovesFromActiveDays() {
        // Arrange
        let day = "Tue"
        habit.activeDays.append(day)
        
        // Act
        viewModel.toggleDaySelection(day)
        
        // Assert
        XCTAssertFalse(habit.activeDays.contains(day), "Day should be removed from activeDays")
    }
    
    func testSelectingAllDays() {
        // Act
        viewModel.toggleAllDays()
        
        // Assert
        XCTAssertEqual(habit.activeDays.count, viewModel.weekdays.count, "All days should be selected")
    }
    
    func testDeselectingAllDays() {
        // Arrange
        habit.activeDays = viewModel.weekdays
        
        // Act
        viewModel.toggleAllDays()
        
        // Assert
        XCTAssertTrue(habit.activeDays.isEmpty, "All days should be deselected")
    }
    
    func testSavingChangesUpdatesSwiftData() {
        // Arrange
        let day = "Wed"
        let initialCount = habit.activeDays.count
        
        // Act
        viewModel.toggleDaySelection(day)
        
        // Assert
        XCTAssertNotEqual(habit.activeDays.count, initialCount, "ActiveDays should be updated in SwiftData")
    }
}
