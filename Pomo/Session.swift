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
    
    init(taskName: String, duration: Int, startTime: Date, endTime: Date) {
        self.taskName = taskName
        self.duration = duration
        self.startTime = startTime
        self.endTime = endTime
    }
}
