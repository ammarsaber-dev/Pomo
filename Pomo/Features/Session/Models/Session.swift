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
            return "\(minutes < 1 ? "less than a minute" : "\(minutes) minute\(minutes > 1 ? "s": "")")"
        } else if minutes % 60 == 0 {
            return "\(minutes / 60) hour\(minutes / 60 > 1 ? "s" : "")"
        }
        return "\(minutes / 60) hours and \(minutes % 60) minutes"
    }
    
    var formattedDate: String {
        endTime.formatted(date: .abbreviated, time: .omitted)
    }
    
    var formattedTime: String {
        let formattedEndTime = endTime.formatted(date: .omitted, time: .shortened)
        let formattedStartTime = startTime.formatted(date: .omitted, time: .shortened)
        
        return formattedEndTime == formattedStartTime ? formattedEndTime : formattedStartTime + " - " + formattedEndTime
    }

    init(taskName: String, duration: Int, startTime: Date, endTime: Date) {
        self.taskName = taskName
        self.duration = duration
        self.startTime = startTime
        self.endTime = endTime
    }
}
