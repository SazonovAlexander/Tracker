import Foundation
import AppMetricaCore


final class AnalyticManager {
    enum Events: String {
        case open = "open"
        case close = "close"
        case click = "click"
    }
    
    enum Screens: String {
        case main = "Main"
    }
    
    enum Items: String {
        case add_track = "add_track"
        case track = "track"
        case filter = "filter"
        case edit = "edit"
        case delete = "delete"
    }
    static let shared = AnalyticManager()
    
    private init() {
        if let configuration = AppMetricaConfiguration(apiKey: "c23cde54-c6ee-49ed-9931-fc252199b7a6") {
            AppMetrica.activate(with: configuration)
        }
    }
 
    public func report(event: Events, screen: Screens, item: Items? = nil) {
        let params : [AnyHashable : Any]
        if event != .open && event != .close, let item {
            params = ["event": event.rawValue, "screen": screen.rawValue, "item": item.rawValue]
        } else {
            params = ["event": event.rawValue, "screen": screen.rawValue]
        }
        AppMetrica.reportEvent(name: "EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
