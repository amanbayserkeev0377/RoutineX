//
//  RoutineXApp.swift
//  RoutineX
//
//  Created by Aman on 22/3/25.
//

import SwiftData
import SwiftUI

@main
struct RoutineXApp: App {
    var body: some Scene {
        WindowGroup {
            Text("RoutineX will start here")
                .padding()
        }
        .modelContainer(SwiftDataManager.sharedContainer)
    }
}
