import Foundation


final class TrackerDate {
    
    private static let calendar = Calendar.current
    private static let date = Date()
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    static func dayOfDate(_ date: Date) -> Days {
        switch calendar.component(.weekday, from: date) {
        case 1:
            return Days.sunday
        case 2:
            return Days.monday
        case 3:
            return Days.tuesday
        case 4:
            return Days.wednesday
        case 5:
            return Days.thursday
        case 6:
            return Days.friday
        case 7:
            return Days.saturday
        default:
            return Days.monday
        }
    }
    
    static func currentDate() -> Date {
        dateWithoutTime(from: date)
    }
    
    static func dateWithoutTime(from: Date) -> Date {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: from)
        return calendar.date(from: dateComponents) ?? self.date
    }
    
}


