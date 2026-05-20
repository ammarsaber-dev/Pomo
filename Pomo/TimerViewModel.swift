//
//  TimerViewModel.swift
//  Pomo
//
//  Created by Ammar Saber on 20/05/2026.
//

import Foundation
import SwiftData

@Observable
class TimerViewModel {
    private var timer: Timer?

    var totalSeconds = 1500
    var task = ""
    var timerSeconds = 1500
    var isRunning = false

    let durations = [1, 5, 25, 30, 45]
    var selectedDuration = 25

    private var startTime: Date = .init()

    var timeDisplay: String {
        let minutes = timerSeconds / 60
        let remainingSeconds = timerSeconds % 60

        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    var progress: Double {
        Double(timerSeconds) / Double(totalSeconds)
    }

    var showCompletionAlert = false

    func toggleTimer(context: ModelContext) {
        if !isRunning {
            startTime = .now
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
                _ in
                // Capture self so the closure can reference this specific instance when it fires later
                self.tick(context: context)
            }
        } else {
            stop()
        }
    }

    func reset() {
        stop()
        timerSeconds = totalSeconds
    }

    func selectDuration(_ duration: Int) {
        stop()
        totalSeconds = duration * 60
        timerSeconds = duration * 60
        selectedDuration = duration
    }

    private func saveSession(context: ModelContext) {
        let session = Session(
            taskName: task,
            duration: totalSeconds,
            startTime: startTime,
            endTime: .now
        )
        context.insert(session)
        print("Session saved: \(task)")
    }

    private func tick(context: ModelContext) {
        if timerSeconds > 0 {
            timerSeconds -= 1
        } else {
            stop()
            saveSession(context: context)
            showCompletionAlert = true
            timerSeconds = totalSeconds
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
}
