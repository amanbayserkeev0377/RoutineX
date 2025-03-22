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

    private let timerFactory: (TimeInterval, Bool, @escaping (Timer) -> Void) -> Timer?

    init(
        timerFactory: @escaping (
            TimeInterval, Bool, @escaping (Timer) -> Void
        ) -> Timer? = { interval, repeats, block in
        Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: repeats,
            block: block
        )
    }
    ) {
        self.timerFactory = timerFactory
    }

    func start(duration: TimeInterval) {
        guard !isRunning else { return }
        self.duration = duration
        self.remainingTime = duration
        self.startDate = Date()
        self.isRunning = true

        timer = timerFactory(1.0, true) { [weak self] _ in
            self?.tick()
        }

        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
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

    public func tick() {
        guard isRunning else { return }
        guard remainingTime > 0 else {
            complete()
            return
        }

        remainingTime -= 1

        if remainingTime <= 0 {
            complete()
        }
    }

    private func complete() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingTime = 0
        onFinish?()
    }
}
