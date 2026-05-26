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
                    TimerRingView(
                        viewModel: viewModel,
                        isTaskFieldFocused: $isTaskFieldFocused
                    )

                    if viewModel.mode == .focus {
                        Picker(
                            "Duration",
                            selection: $viewModel.selectedDuration
                        ) {
                            ForEach(viewModel.durations, id: \.self) { d in
                                Text(viewModel.durationLabel(d))
                                    .tag(d)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: viewModel.selectedDuration) {
                            _,
                            newValue in
                            withAnimation {
                                viewModel.selectDuration(newValue)
                            }
                        }
                    }
                }

                Spacer()

                TimerControlsView(
                    viewModel: viewModel,
                    modelContext: modelContext
                )

            }
            .padding()
            .overlay {
                CompletionOverlayView(
                    viewModel: viewModel,
                    modelContext: modelContext
                )
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
