import Foundation

enum Filters: String{
    case all = "all"
    case current = "current"
    case completed = "completed"
    case uncompleted = "uncompleted"

    func localizedString() -> String {
        NSLocalizedString("filters." + self.rawValue, comment: self.rawValue + "filter")
    }
}

