import Foundation


enum Days: String, Codable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    
    var localizedShortString: String {
        NSLocalizedString(self.rawValue + "_short", comment: "Short string of Days." + self.rawValue)
    }
    
    var localizedString: String {
        NSLocalizedString(self.rawValue, comment: "Days." + self.rawValue)
    }
}

