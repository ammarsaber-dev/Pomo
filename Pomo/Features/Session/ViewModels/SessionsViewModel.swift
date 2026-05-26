//
//  SessionsViewModel.swift
//  Pomo
//
//  Created by Ammar Saber on 26/05/2026.
//

import Foundation
import SwiftData

@Observable
class SessionsViewModel {
    
    func clearAll(context: ModelContext) {
        do {
            try? context.save()  // Force any pending changes to disk before deleting, so nothing is missed
            try context.delete(model: Session.self)
        } catch {
            print("Failed to clear sessions: \(error)")
        }
    }
    
    func delete(_ sessions: [Session], at indexSet: IndexSet, context: ModelContext) {
        for index in indexSet {
            context.delete(sessions[index])
        }
    }
}
