//
//  Session.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

import Foundation
import SwiftData

@Model
class Session {
    var taskName: String
    var duration: Int
    var startTime: Date
    var endTime: Date

    var durationLabel: String {
        let minutes = duration / 60
        if minutes < 60 {
            return "\(minutes)m"
        } else if minutes % 60 == 0 {
            return "\(minutes / 60)h"
        }
        return "\(minutes / 60)h \(minutes % 60)m"
    }

    init(taskName: String, duration: Int, startTime: Date, endTime: Date) {
        self.taskName = taskName
        self.duration = duration
        self.startTime = startTime
        self.endTime = endTime
    }
}
