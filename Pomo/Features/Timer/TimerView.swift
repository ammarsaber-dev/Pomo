//
//  TimerView.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

import SwiftUI
import SwiftData

struct TimerView: View {
    // used to write into a database
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = TimerViewModel()

    var body: some View {
        VStack {
            VStack {
                TextField("Type your task here", text: $viewModel.task)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24))
                    .foregroundStyle(.primary)
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

                        Text(viewModel.timeDisplay)
                            .font(.system(size: 80))
                            .fontWeight(.black)
                            .contentTransition(.numericText())
                    }

                    HStack {
                        ForEach(viewModel.durations, id: \.self) { d in
                            Button(viewModel.durationLabel(d)) {
                                withAnimation {
                                    viewModel.selectDuration(d)
                                }
                            }
                            .foregroundStyle(.primary)
                            .underline(d == viewModel.selectedDuration)
                        }
                    }
                }
            }

            Spacer()

            VStack {
                Button(viewModel.timerButtonLabel) {
                    viewModel.toggleTimer(context: modelContext)
                }
                .disabled(viewModel.task.isEmpty || viewModel.timerSeconds == 0)
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
                .disabled(!viewModel.isRunning && viewModel.timerSeconds == viewModel.totalSeconds)
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .padding()
        .alert("Session Complete 🎉", isPresented: $viewModel.showCompletionAlert) {
            Button("Keep Going") { }
        } message: {
            Text("You completed \"\(viewModel.task)\". Take a short break, you earned it.")
        }
    }
}

#Preview {
    TimerView()
}
