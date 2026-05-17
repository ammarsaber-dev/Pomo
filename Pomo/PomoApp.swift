//
//  PomoApp.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

import SwiftData
import SwiftUI

@main
struct PomoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: Session.self)
    }
}
