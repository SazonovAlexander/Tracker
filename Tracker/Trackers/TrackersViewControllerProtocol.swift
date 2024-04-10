import Foundation


protocol TrackersViewControllerProtocol: AnyObject {
    
    func getCategories() -> [TrackerCategory]
    
    func addTracker(_ category: TrackerCategory)
    
    func changeTracker(_ tracker: Tracker)
    
    func setFilter(_ filter: Filters)
    
}
