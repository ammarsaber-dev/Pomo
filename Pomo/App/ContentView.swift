//
//  ContentView.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Timer", systemImage: "timer") {
                TimerView()
            }
            
            Tab("Sessions", systemImage: "list.bullet") {
                SessionsView()
            }
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
