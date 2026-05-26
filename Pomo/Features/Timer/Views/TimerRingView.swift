//
//  TimerRingView.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import SwiftData
import SwiftUI

struct TimerRingView: View {
    @Bindable var viewModel: TimerViewModel  // @Bindable to make $viewModel.task works
    @FocusState.Binding var isTaskFieldFocused: Bool

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 1 - viewModel.progress, to: 1)
                .stroke(
                    viewModel.mode == .focus
                        ? Color.primary : Color.green.opacity(0.6),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(
                    .smooth,
                    value: viewModel.remainingSeconds
                )
            VStack(spacing: 0) {
                Text(viewModel.timeDisplay)
                    .font(.system(size: 80))
                    .fontWeight(.black)
                    .contentTransition(.numericText())

                if viewModel.mode == .focus {
                    TextField(
                        "What are you working on?",
                        text: $viewModel.task
                    )
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .focused($isTaskFieldFocused)
                } else {
                    Text(viewModel.currentBreakMessage)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .id(viewModel.currentBreakMessage)
                        .transition(
                            .opacity.combined(with: .scale(scale: 0.95))
                        )
                }
            }
            .animation(.smooth, value: viewModel.currentBreakMessage)
        }
    }
}
