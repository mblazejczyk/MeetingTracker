import SwiftUI
import SwiftData

@main
struct MeetingTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Meeting.self)
        }
    }
}
