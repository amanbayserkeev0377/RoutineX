// ActiveDayEntity.swift

import Foundation
import SwiftData

@Model
final class ActiveDayEntity {
    var day: String

    init(day: String) {
        self.day = day
    }
}
