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

    @State private var showClearAlert = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(sessions, id: \.self) { session in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(session.taskName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text(session.durationLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                                Text(session.formattedTime)
                                Text(session.formattedDate)
                                .font(.footnote)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                if !sessions.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear") {
                            showClearAlert = true
                        }
                    }
                }
            }
            .alert(
                "Clear all saved sessions?",
                isPresented: $showClearAlert
            ) {
                Button("Clear All", role: .destructive) {
                    do {
                        try? modelContext.save()  // Force any pending changes to disk before deleting, so nothing is missed
                        try modelContext.delete(model: Session.self)
                    } catch {
                        print("Failed to clear sessions: \(error)")
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
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
