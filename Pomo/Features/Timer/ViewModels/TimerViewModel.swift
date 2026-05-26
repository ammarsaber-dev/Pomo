//
//  TimerViewModel.swift
//  Pomo
//
//  Created by Ammar Saber on 20/05/2026.
//

import AVFoundation
import Foundation
import SwiftData

enum TimerMode {
    case focus, rest
}


@Observable
class TimerViewModel {
    
    enum Sounds: String {
        case clockTick = "clock-tick"
        case completed = "completed"
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    private var timer: Timer?

    var mode: TimerMode = .focus
    
    static let breakMessages = [
        "Take a breath",
        "Rest your eyes",
        "Stand up and stretch",
        "Drink some water",
        "You earned this"
    ]
    
    var currentBreakMessage = breakMessages[0]
    
    let durations = [1, 5, 25, 30, 45, 60]

    var task = ""
    var isRunning = false

    var selectedDuration = 25
    var sessionDuration = 25 * 60
    var remainingSeconds = 25 * 60
    
    private let breakDuration = 5 * 60
    

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
        if isRunning {
            return "Pause"
        } else if mode == .rest {
            return "Resume Break"
        } else if remainingSeconds == sessionDuration {
            return "Start"
        }
        
        return "Resume"
    }
    
    func startBreak(context: ModelContext) {
        mode = .rest
        
        // 5 minutes break
        remainingSeconds = breakDuration
        sessionDuration = breakDuration
        
        toggleTimer(context: context)
    }
    
    func skipBreak() {
        stop()
        mode = .focus

        sessionDuration = selectedDuration * 60
        remainingSeconds = selectedDuration * 60
    }

    func toggleTimer(context: ModelContext) {
        if !isRunning {
            startTime = .now
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
                tick(context: context)
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
            playSound(.clockTick)
            
            changeBreakMessages()
            
        } else {
            if mode == .focus {
                handleFocusComplete(context: context)
            } else {
                mode = .focus
            }
            stop()
            remainingSeconds = sessionDuration
        }
    }
    
    private func changeBreakMessages() {
        if mode == .rest && remainingSeconds % 10 == 0 {
            currentBreakMessage = TimerViewModel.breakMessages.randomElement()!
        }
    }
    
    private func handleFocusComplete(context: ModelContext) {
        saveSession(context: context)
        showCompletionOverlay = true
        playSound(.completed)
    }

    
    private func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func playSound(_ sound: Sounds) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
}
