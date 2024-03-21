import UIKit
import CoreData


enum TrackerCategoryStoreError: Error {
    case decodingError
    case categoryNotFound
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
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
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCategoryCoreData.name), ascending: false)
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
    
    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.category(from: $0) })
        else { return [] }
        return categories
    }
    
    func addCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        try updateExistingCategory(trackerCategoryCoreData, with: trackerCategory)
    }

    private func updateExistingCategory(_ trackerCategoryCoreData: TrackerCategoryCoreData, with trackerCategory: TrackerCategory) throws {
        trackerCategoryCoreData.id = trackerCategory.id
        trackerCategoryCoreData.name = trackerCategory.name
        trackerCategoryCoreData.trackers = Set(try trackerCategory.trackers.map( {
            if let trackerCoreData = try? trackerStore.getTrackerById($0.id) {
                return trackerCoreData
            } else {
                try trackerStore.addNewTracker($0)
                return try trackerStore.getTrackerById($0.id)
            }
            }
            )) as NSSet
        try context.save()
    }
    
    func updateCategory(_ trackerCategory: TrackerCategory) throws {
        let categoryCoreData = try getCategoryById(trackerCategory.id)
        try updateExistingCategory(categoryCoreData, with: trackerCategory)
    }
    
    func getCategoryById(_ id: UUID) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        guard let category = try context.fetch(request).first else {
            throw TrackerCategoryStoreError.categoryNotFound
        }
        
        return category
    }
    
    func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let id = trackerCategoryCoreData.id,
              let name = trackerCategoryCoreData.name,
              let trackersCoreData = trackerCategoryCoreData.trackers as? Set<TrackerCoreData>,
              let trackers = try? trackersCoreData.map({try trackerStore.tracker(from: $0)})
        else {
            throw TrackerCategoryStoreError.decodingError
        }
        return TrackerCategory(id: id, name: name, trackers: Array(trackers))
    }
    
}


extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(self)
    }
    
}

