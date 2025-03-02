import Foundation
import CoreData


extension HabitEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitEntity> {
        return NSFetchRequest<HabitEntity>(entityName: "HabitEntity")
    }

    @NSManaged public var color: String?
    @NSManaged public var completionHistory: NSArray
    @NSManaged public var createdAt: Date?
    @NSManaged public var days: NSArray
    @NSManaged public var goal: Double
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var progress: Double
    @NSManaged public var repeatOption: String?
    @NSManaged public var title: String?
    @NSManaged public var progressValue: Double

}

extension HabitEntity : Identifiable {

}
