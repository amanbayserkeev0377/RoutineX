//
//  Array+SafeTests.swift
//  RoutineXTests
//
//  Created by Aman on 22/3/25.
//

import Testing
@testable import RoutineX

struct Array_SafeTests {

    @Test
    func testSafeAccessWithinBounds() async throws {
        let array = [10, 20, 30]
        #expect(array[safe: 1] == 20)
    }

    @Test
    func testSafeAccessOutOfBoundsReturnsNil() async throws {
        let array = [10, 20, 30]
        #expect(array[safe: 5] == nil)
        #expect(array[safe: -1] == nil)
    }
}
