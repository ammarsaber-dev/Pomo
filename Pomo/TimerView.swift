//
//  TimerView.swift
//  Pomo
//
//  Created by Ammar Saber on 17/05/2026.
//

internal import Combine
import SwiftUI
import SwiftData

struct TimerView: View {
    // used to write into the database
    @Environment(\.modelContext) private var modelContext
    
    @State private var totalSeconds = 1500

    @State private var task = ""
    @State private var timerSeconds = 1500
    @State private var isRunning = false

    let durations = [5, 25, 30, 45]
    @State private var selectedDuration = 25
    
    @State private var startTime: Date = .init()

    private var timeDisplay: String {
        let minutes = timerSeconds / 60
        let remainingSeconds = timerSeconds % 60

        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    private var progress: Double {
        Double(timerSeconds) / Double(totalSeconds)
    }

    var body: some View {
        VStack {
            VStack {
                TextField("Type your task here", text: $task)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24))
                    .foregroundStyle(.primary)
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .trim(from: 1 - progress, to: 1)
                            .stroke(
                                .primary,
                                style: StrokeStyle(
                                    lineWidth: 8,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))

                        Text(timeDisplay)
                            .font(.system(size: 80))
                            .fontWeight(.black)
                    }

                    HStack {
                        ForEach(durations, id: \.self) { d in
                            Button("\(d) min") {
                                isRunning = false
                                totalSeconds = d * 60
                                timerSeconds = d * 60
                                selectedDuration = d
                            }
                            .foregroundStyle(.primary)
                            .underline(d == selectedDuration)
                        }
                    }
                }
            }

            Spacer()

            VStack {
                Button(isRunning ? "Pause" : "Start") {
                    if !isRunning {
                        startTime = .now
                    }
                    
                    isRunning.toggle()
                }
                .disabled(task.isEmpty || timerSeconds == 0)
                .opacity(task.isEmpty ? 0.5 : 1)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(.background)
                .background(task.isEmpty ? .secondary : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button("Reset") {
                    isRunning = false
                    timerSeconds = totalSeconds
                }
                .disabled(isRunning)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding()
        .onReceive(
            Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        ) { _ in
            // this runs every second
            if isRunning {
                if timerSeconds > 0 {
                    timerSeconds -= 1
                } else {
                    let session = Session(taskName: task, duration: totalSeconds, startTime: startTime, endTime: .now)
                    modelContext.insert(session)
                    print("Session saved: \(task)")
                    isRunning = false
                }
            }
        }
    }
}

#Preview {
    TimerView()
}
