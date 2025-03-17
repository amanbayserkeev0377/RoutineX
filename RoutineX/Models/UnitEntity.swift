// UnitEntity.swift

import SwiftData

@Model
final class UnitEntity {
    @Attribute(.unique) var name: String
    
    init(name: String) {
        self.name = name
    }
}
