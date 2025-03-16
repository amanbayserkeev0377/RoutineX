import Foundation
import SwiftData

@Model
final class Habit {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
