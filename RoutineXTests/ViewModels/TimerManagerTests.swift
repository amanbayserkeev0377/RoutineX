import Foundation
import Testing
@testable import RoutineX

struct TimerManagerTests {

    @Test
    func testStartInitializesCorrectly() {
        let timer = TimerManager { _, _, _ in Timer() }
        timer.start(duration: 5)

        #expect(timer.isRunning == true)
        #expect(timer.remainingTime == 5)
    }

    @Test
    func testPauseStopsTimer() {
        let timer = TimerManager { _, _, _ in Timer() }
        timer.start(duration: 5)
        
        timer.tick()
        timer.pause()
        
        let pausedTime = 4.0
        timer.tick()

        #expect(timer.isRunning == false)
        #expect(timer.remainingTime == pausedTime)
    }

    @Test
    func testResetRestoresDuration() {
        let timer = TimerManager { _, _, _ in Timer() }
        timer.start(duration: 5)
        timer.tick()
        
        #expect(timer.remainingTime == 4)
        
        timer.reset()

        #expect(timer.remainingTime == 5)
        #expect(timer.isRunning == false)
    }

    @Test
    func testOnFinishCalledWhenTimerCompletes() {
        let timer = TimerManager { _, _, _ in Timer() }
        var didFinish = false

        timer.onFinish = {
            didFinish = true
        }

        timer.start(duration: 2)
        timer.tick()
        #expect(timer.remainingTime == 1)
        
        timer.tick()
        
        #expect(timer.remainingTime == 0)
        #expect(timer.isRunning == false)
        #expect(didFinish == true)
    }
}
