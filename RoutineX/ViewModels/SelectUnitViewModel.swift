import SwiftData
import SwiftUI

@MainActor
@Observable
class SelectUnitViewModel {
    var selectedUnit: String
    var isEditing = false
    var showTextField = false
    var customUnit = ""
    private(set) var customUnits: [UnitEntity] = []
    
    let standardUnits = ["count", "cycles", "pages", "sec", "min", "hr", "steps", "mile", "km", "ml", "oz", "Cal", "mg", "g", "drink"]
    
    init(selectedUnit: String) {
        self.selectedUnit = selectedUnit
        loadCustomUnits()
    }
    
    func loadCustomUnits() {
        customUnits = SwiftDataManager.shared.fetchCustomUnits()
    }
    
    func addCustomUnit() {
        let trimmedUnit = customUnit.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedUnit.isEmpty,
              !standardUnits.contains(trimmedUnit),
              !customUnits.contains(where: { $0.name == trimmedUnit }) else {
            return
        }
        
        SwiftDataManager.shared.addCustomUnit(trimmedUnit)
        loadCustomUnits()
        selectedUnit = trimmedUnit
        customUnit = ""
        showTextField = false
    }
    
    func deleteCustomUnit(_ unit: UnitEntity) {
        SwiftDataManager.shared.deleteCustomUnit(unit)
        loadCustomUnits()
    }
    
    func toggleEditing() {
        isEditing.toggle()
    }
}
