//
//  CompletionOverlayView.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import SwiftUI
import SwiftData

struct CompletionOverlayView: View {
    let viewModel: TimerViewModel
    let modelContext: ModelContext
    
    var body: some View {
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
}
