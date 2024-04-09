import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersViewControllerLight() {
        let vc = TrackersViewController()
        
        vc.updateDate(TrackerDate.dateWithoutTime(from: Date(timeIntervalSince1970: 0)))
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerDark() {
        let vc = TrackersViewController()
        
        vc.updateDate(TrackerDate.dateWithoutTime(from: Date(timeIntervalSince1970: 0)))
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
