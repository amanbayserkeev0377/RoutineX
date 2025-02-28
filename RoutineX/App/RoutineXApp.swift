//
//  RoutineXApp.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

@main
struct RoutineXApp: App {
    
    let coreDataManager = CoreDataManager()
    
    @StateObject var habitViewModel = HabitViewModel(context: CoreDataManager.shared.context)
    
    var body: some Scene {
        WindowGroup {
            MyHabitsView()
                .environmentObject(habitViewModel)
                .environment(\.managedObjectContext, coreDataManager.context)
        }
    }
}
