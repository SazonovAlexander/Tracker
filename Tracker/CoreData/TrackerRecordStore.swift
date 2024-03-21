import UIKit
import CoreData


enum TrackerRecordStoreError: Error {
    case decodingError
    case recordNotFound
}

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore)
}

final class TrackerRecordStore: NSObject {
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    private var trackerStore: TrackerStore

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext,
         trackerStore: TrackerStore = TrackerStore()) throws {
        self.context = context
        self.trackerStore = trackerStore
        super.init()
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerRecordCoreData.date), ascending: false)
                ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    var records: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try self.record(from: $0) })
        else { return [] }
        return records
    }
    
    func addRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        try updateExistingRecord(trackerRecordCoreData, with: trackerRecord)
    }

    private func updateExistingRecord(_ trackerRecordCoreData: TrackerRecordCoreData, with trackerRecord: TrackerRecord) throws {
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.tracker = try trackerStore.getTrackerById(trackerRecord.trackerId)
        trackerRecordCoreData.date = trackerRecord.date
        try context.save()
    }
    
    func deleteRecord(id: UUID) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        if let record = try context.fetch(request).first {
            context.delete(record)
            try context.save()
        }
    }
    
    func record(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.id,
              let trackerId = trackerRecordCoreData.tracker?.id,
              let date = trackerRecordCoreData.date
        else {
            throw TrackerRecordStoreError.decodingError
        }
        return TrackerRecord(id: id, trackerId: trackerId, date: date)
    }
    
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(self)
    }
    
}
