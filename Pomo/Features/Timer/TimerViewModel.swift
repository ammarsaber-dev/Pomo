//
//  TimerViewModel.swift
//  Pomo
//
//  Created by Ammar Saber on 20/05/2026.
//

import AVFoundation
import Foundation
import SwiftData

@Observable
class TimerViewModel {
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    let durations = [1, 5, 25, 30, 45, 60]

    var task = ""
    var isRunning = false

    var selectedDuration = 25
    var sessionDuration = 25 * 60

    var remainingSeconds = 25 * 60

    private var startTime: Date = .init()

    var showCompletionOverlay = false

    var timeDisplay: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var progress: Double {
        Double(remainingSeconds) / Double(sessionDuration)
    }

    var timerButtonLabel: String {
        if remainingSeconds == sessionDuration && !isRunning {
            return "Start"
        } else if isRunning {
            return "Pause"
        }

        return "Resume"
    }

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
        remainingSeconds = sessionDuration
    }

    func selectDuration(_ duration: Int) {
        stop()
        sessionDuration = duration * 60
        remainingSeconds = duration * 60
        selectedDuration = duration
    }

    func durationLabel(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        } else if minutes % 60 == 0 {
            return "\(minutes / 60)h"
        }

        return "\(minutes / 60)h \(minutes % 60)m"
    }

    private func saveSession(context: ModelContext) {
        let session = Session(
            taskName: task,
            duration: sessionDuration,
            startTime: startTime,
            endTime: .now
        )
        context.insert(session)
    }

    private func tick(context: ModelContext) {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            playCompletionSound("clock-tick")
        } else {
            playCompletionSound("completed")
            stop()
            saveSession(context: context)
            showCompletionOverlay = true
            remainingSeconds = sessionDuration
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func playCompletionSound(_ file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "mp3")
        else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
}
