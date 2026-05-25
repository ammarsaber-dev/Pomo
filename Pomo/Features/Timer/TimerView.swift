//
//  TimerView.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

import SwiftData
import SwiftUI

struct TimerView: View {
    // used to write into a database
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TimerViewModel()

    @FocusState private var isTaskFieldFocused: Bool

    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .trim(from: 1 - viewModel.progress, to: 1)
                            .stroke(
                                viewModel.mode == .focus ? Color.primary : Color.green.opacity(0.6),
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
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                            }
                        }
                        .animation(.smooth, value: viewModel.currentBreakMessage)
                    }
                    if viewModel.mode == .focus {
                        Picker("Duration", selection: $viewModel.selectedDuration) {
                            ForEach(viewModel.durations, id: \.self) { d in
                                Text(viewModel.durationLabel(d))
                                    .tag(d)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: viewModel.selectedDuration) { _, newValue in
                            withAnimation {
                                viewModel.selectDuration(newValue)
                            }
                        }
                    }
                }

                Spacer()

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
            .padding()
            .overlay {
                ZStack {
                    if viewModel.showCompletionOverlay {
                        VStack {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Session Complete")
                            }
                            .font(.largeTitle)
                            .fontWeight(.bold)

                            VStack {
                                Text("\(viewModel.task)")
                                HStack {
                                    Button("Keep Going?") {
                                        viewModel.showCompletionOverlay = false
                                    }

                                    Button("Take a break") {
                                        viewModel.startBreak(context: modelContext)
                                        viewModel.showCompletionOverlay = false
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .clipShape(.rect(cornerRadius: 16))
                                }
                            }

                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                    }
                }
                .transition(.opacity)
                .animation(.smooth, value: viewModel.showCompletionOverlay)
            }
            .onAppear {
                isTaskFieldFocused = true
            }
        }
    }
}

#Preview {
    TimerView()
}
