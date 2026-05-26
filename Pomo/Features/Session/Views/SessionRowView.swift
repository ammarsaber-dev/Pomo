//
//  SessionRowView.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import SwiftUI

struct SessionRowView: View {
    let session: Session
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(session.taskName)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(session.durationLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                    Text(session.formattedTime)
                    .font(.subheadline)
                    Text(session.formattedDate)
                    .font(.footnote)
            }
            .foregroundStyle(.secondary)
        }
    }
}
