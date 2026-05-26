//
//  SessionsView.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

import SwiftData
import SwiftUI

struct SessionsView: View {
    @State private var viewModel = SessionsViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var sessions: [Session]

    @State private var showClearAlert = false

    var body: some View {
        NavigationStack {
            List {
                // persistentModelID is a SwiftData built-in unique ID for each object.
                ForEach(sessions, id: \.persistentModelID) { session in
                    SessionRowView(session: session)
                }
                .onDelete { indexSet in
                    viewModel.delete(sessions, at: indexSet, context: modelContext)
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
                    viewModel.clearAll(context: modelContext)
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
