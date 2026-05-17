//
//  SessionsView.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

import SwiftData
import SwiftUI

struct SessionsView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var sessions: [Session]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sessions, id: \.self) { session in
                    HStack {
                        Text(session.taskName)
                        Spacer()
                        Text("\(session.duration / 60) min")
                    }
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                if !sessions.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            try? modelContext.delete(model: Session.self)
                        }
                    }
                }
            }
            .overlay {
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "No Saved Sessions Yet",
                        systemImage: "clock.badge.checkmark",
                        description: Text(
                            "Complete a focus session to see it here."
                        )
                    )
                }
            }
        }
    }
}

#Preview {
    SessionsView()
}
