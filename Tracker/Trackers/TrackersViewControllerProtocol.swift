import Foundation


protocol TrackersViewControllerProtocol: AnyObject {
    
    func getCategories() -> [TrackerCategory]
    
    func addTracker(_ category: TrackerCategory)
    
}
