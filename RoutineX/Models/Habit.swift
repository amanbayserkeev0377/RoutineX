//
//  Habit.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import Foundation
import FirebaseFirestore

struct Habit: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var icon: String
    var color: String
    var goal: Double
    var progress: Double
    var createdAt: Date
}
