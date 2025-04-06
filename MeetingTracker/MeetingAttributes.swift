import SwiftUI
import ActivityKit

struct MeetingAttributes: ActivityAttributes {
    public typealias MeetingStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var startTime: Date
    }
    
    var meetingInfo: String = String(localized: "Meeting in progress...")
}
