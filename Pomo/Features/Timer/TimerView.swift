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
                                .primary,
                                style: StrokeStyle(
                                    lineWidth: 8,
                                    lineCap: .round
                                )
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

                            TextField(
                                "What are you working on?",
                                text: $viewModel.task
                            )
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .focused($isTaskFieldFocused)
                        }
                    }
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

                Spacer()

                VStack {
                    Button(viewModel.timerButtonLabel) {
                        viewModel.toggleTimer(context: modelContext)
                    }
                    .disabled(
                        viewModel.task.isEmpty
                            || viewModel.remainingSeconds == 0
                    )
                    .opacity(viewModel.task.isEmpty ? 0.5 : 1)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .buttonStyle(.plain)
                    .foregroundStyle(.background)
                    .background(viewModel.task.isEmpty ? .secondary : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    Button("Reset") {
                        withAnimation {
                            viewModel.reset()
                        }

                    }
                    .buttonStyle(.plain)
                    .disabled(
                        !viewModel.isRunning
                            && viewModel.remainingSeconds
                                == viewModel.sessionDuration
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
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
                                Text("Tap to dismiss")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.showCompletionOverlay = false
                            }
                        }
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
