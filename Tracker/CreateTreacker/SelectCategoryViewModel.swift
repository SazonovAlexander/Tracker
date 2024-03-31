import Foundation


typealias Binding<T> = (T) -> Void

final class SelectCategoryViewModel {
    
    var categories: Binding<[TrackerCategory]>?
    var selectedCategory: Binding<TrackerCategory>?
    
    private let trackerCategoryStore: TrackerCategoryStore
    
    init(trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerCategoryStore.delegate = self
    }
    
    func addCategory(name: String) throws {
        let category = TrackerCategory(id: UUID(), name: name, trackers: [])
        try trackerCategoryStore.addCategory(category)
    }
    
    func getCategories() {
        store(trackerCategoryStore)
    }
    
    func setSelectedCategory(_ category: TrackerCategory) {
        selectedCategory?(category)
    }
}

extension SelectCategoryViewModel: TrackerCategoryStoreDelegate {
    
    func store(_ store: TrackerCategoryStore) {
        categories?(store.categories)
    }
}
