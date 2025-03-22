//
//  SwiftDataManager.swift
//  RoutineX
//
//  Created by Aman on 22/3/25.
//

import Foundation
import SwiftData

enum SwiftDataManager {
    static var sharedContainer: ModelContainer = {
        let schema = Schema([
            Habit.self
        ])
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("[ERROR] Failed to create ModelContainer: \(error)")
        }
    }()
}
