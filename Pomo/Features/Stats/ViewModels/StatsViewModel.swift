//
//  StatsViewModel.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import Foundation

class StatsViewModel {
    func totalSessions(_ sessions: [Session]) -> Int {
        sessions.count
    }

    func totalFocusTime(_ sessions: [Session]) ->  Int {
        sessions.reduce(0) { $0 + $1.duration }
    }

    func currentStreak(_ sessions: [Session]) -> Int {
        // get all unique days that have at least one session
        let calendar = Calendar.current
        let sessionDays = Set(
            sessions.map { calendar.startOfDay(for: $0.endTime) }
        )

        // start from today counting backwards
        // stop when I hit a day with no session
        var streak = 0
        var date = calendar.startOfDay(for: .now)

        if !sessionDays.contains(date) {
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) {
                date = calendar.startOfDay(for: yesterday)
            }
        }

        while sessionDays.contains(date) {
            streak += 1
            date = calendar.date(byAdding: .day, value: -1, to: date)!  //  moves back one day each iteration
        }

        return streak
    }
    
    
    func findBestDay(_ sessions: [Session]) -> Date? {
        let calendar = Calendar.current
        var counts: [Date: Int]  = [:]
        for session in sessions {
            let day = calendar.startOfDay(for: session.endTime)
            counts[day, default: 0] += 1
        }
        
        return counts.max { $0.value < $1.value }?.key
    }
    
    
    func totalFocusMinutes(_ sessions: [Session]) -> Int {
        return totalFocusTime(sessions) / 60
    }

}
