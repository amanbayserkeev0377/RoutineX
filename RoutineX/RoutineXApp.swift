//
//  RoutineXApp.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI
import Firebase

@main
struct RoutineXApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var habitViewModel = HabitViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.user == nil {
                AuthView()
                    .environmentObject(authViewModel)
            } else {
                MyHabitsView()
                    .environmentObject(authViewModel)
                    .environmentObject(habitViewModel)
            }
        }
    }
}
