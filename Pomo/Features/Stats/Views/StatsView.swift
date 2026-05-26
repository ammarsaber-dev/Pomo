//
//  StatsView.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import SwiftData
import SwiftUI

struct StatsView: View {
    @State private var viewModel = StatsViewModel()
    @Query private var sessions: [Session]
        
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Image(systemName: "flame.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(.red.gradient)
                Text("\(viewModel.currentStreak(sessions))")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("Day Streak")
                    .font(.headline)
            }
            
            Spacer()
            
            VStack {
                Text("Your Stats")
                    .foregroundStyle(.primary)
                    
                HStack {
                    VStack(alignment: .center) {
                        Text("\(viewModel.totalFocusMinutes(sessions))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Minutes")
                            .font(.footnote)
                    }

                    Spacer()
                    
                    VStack(alignment: .center) {
                        if let best = viewModel.findBestDay(sessions) {
                            Text(TimeFormatter.bestDay(best))
                                .font(.title2)
                                .fontWeight(.bold)
                        } else {
                            Text("-")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Text("Best Day")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("\(viewModel.totalSessions(sessions))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Sessions")
                            .font(.footnote)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.background)
                .clipShape(.rect(cornerRadius: 16))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.red.gradient.secondary)
            .clipShape(.rect(cornerRadius: 16))

        }
        .padding()
        
    }
}

#Preview {
    StatsView()
}
