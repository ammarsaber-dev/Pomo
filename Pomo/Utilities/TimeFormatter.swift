//
//  TimeFormatter.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import Foundation

struct TimeFormatter {
    
    static func short(minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        } else if minutes % 60 == 0 {
            return "\(minutes / 60)h"
        }

        return "\(minutes / 60)h \(minutes % 60)m"
    }
    
    static func long(seconds: Int) -> String {
        let minutes = seconds / 60
        if minutes < 60 {
            return "\(minutes) minute\(minutes == 1 ? "": "s")"
        } else if minutes % 60 == 0 {
            return "\(minutes / 60) hour\(minutes / 60 > 1 ? "s" : "")"
        }
        return "\(minutes / 60) hours and \(minutes % 60) minutes"
    }
    
    static func bestDay(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        return date.formatted(.dateTime.day().month())
    }
}
