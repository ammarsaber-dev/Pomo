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
        TimeFormatter.long(seconds: duration)
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
