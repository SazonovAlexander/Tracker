import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidSchedule
    case decodingErrorInvalidColor
    case decodingError
    case trackerNotFound
}

final class TrackerStore {
    
    private let context: NSManagedObjectContext
   
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        try updateExistingTracker(trackerCoreData, with: tracker)
    }

    private func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) throws {
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = UIColor.hexStringFromColor(tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as? NSObject
        try context.save()
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let colorHex = trackerCoreData.color, let color = UIColor.colorFromString(colorHex) else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let emoji = trackerCoreData.emoji
        else {
            throw TrackerStoreError.decodingError
        }
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: trackerCoreData.schedule as? [Days]
        )
    }
    
    func getTrackerById(_ id: UUID) throws -> TrackerCoreData {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        guard let tracker = try context.fetch(request).first else {
            throw TrackerStoreError.trackerNotFound
        }
        
        return tracker
    }
}
