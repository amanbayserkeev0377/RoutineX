//
//  RoutineXTests.swift
//  RoutineXTests
//
//  Created by Aman on 22/3/25.
//

import XCTest
@testable import RoutineX

final class HabitTests: XCTestCase {

    func testIncrement() {
        let habit = Habit(name: "Read", goal: 5, unit: .count, startDate: .now)
        habit.increment()
        XCTAssertEqual(habit.currentValue, 1)
        XCTAssertFalse(habit.isCompleted)

        habit.increment(4)
        XCTAssertEqual(habit.currentValue, 5)
        XCTAssertTrue(habit.isCompleted)
    }

    func testDecrement() {
        let habit = Habit(name: "Drink", goal: 3, unit: .count, startDate: .now)
        habit.increment(3)
        habit.decrement(1)
        XCTAssertEqual(habit.currentValue, 2)
        XCTAssertFalse(habit.isCompleted)
    }

    func testResetProgress() {
        let habit = Habit(name: "Workout", goal: 2, unit: .count, startDate: .now)
        habit.increment(2)
        habit.resetProgress()
        XCTAssertEqual(habit.currentValue, 0)
        XCTAssertFalse(habit.isCompleted)
    }

    func testMinimumGoalIsOne() {
        let habit = Habit(name: "Meditate", goal: 0, unit: .count, startDate: .now)
        XCTAssertEqual(habit.goal, 1)
    }
}
