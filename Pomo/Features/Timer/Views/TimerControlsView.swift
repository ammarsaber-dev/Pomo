//
//  TimerControlsView.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import SwiftUI
import SwiftData

struct TimerControlsView: View {
    let viewModel: TimerViewModel
    let modelContext: ModelContext

    
    var body: some View {
        VStack {
            Button(viewModel.timerButtonLabel) {
                viewModel.toggleTimer(context: modelContext)
            }
            .disabled(viewModel.mode == .focus && (viewModel.task.isEmpty || viewModel.remainingSeconds == 0))
            .opacity(viewModel.task.isEmpty ? 0.5 : 1)
            .frame(maxWidth: .infinity)
            .padding()
            .buttonStyle(.plain)
            .foregroundStyle(.background)
            .background(viewModel.task.isEmpty ? .secondary : (viewModel.mode == .focus ? Color.primary : Color.green.opacity(0.6)))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            if viewModel.mode == .focus {
                Button("Reset") {
                    withAnimation {
                        viewModel.reset()
                    }
                }
                .disabled(
                    !viewModel.isRunning
                    && viewModel.remainingSeconds
                    == viewModel.sessionDuration
                )
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                Button("Skip Break") {
                    withAnimation {
                        viewModel.skipBreak()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
}

