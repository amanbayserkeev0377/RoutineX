//
//  TimerManager.swift
//  RoutineX
//
//  Created by Aman on 22/3/25.
//

import Combine
import Foundation

@Observable
final class TimerManager {
    private var timer: Timer?
    private(set) var remainingTime: TimeInterval = 0
    private var duration: TimeInterval = 0
    private var startDate: Date?
    var isRunning: Bool = false

    var onFinish: (() -> Void)?

    func start(duration: TimeInterval) {
        guard !isRunning else { return }
        self.duration = duration
        self.remainingTime = duration
        self.startDate = Date()
        self.isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }

        RunLoop.current.add(timer!, forMode: .common)
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    func reset() {
        pause()
        remainingTime = duration
    }

    private func tick() {
        guard remainingTime > 0 else {
            timer?.invalidate()
            timer = nil
            isRunning = false
            remainingTime = 0
            onFinish?()
            return
        }

        remainingTime -= 1
    }
}
