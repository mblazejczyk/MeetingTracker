import Foundation
import WatchConnectivity
import SwiftUI
import SwiftData

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    @Environment(\.modelContext) private var context

    var session: WCSession
    private var modelContext: ModelContext

    init(session: WCSession = .default, modelContext: ModelContext) {
        self.session = session
        self.modelContext = modelContext
        super.init()
        session.delegate = self
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        // No-op
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let meetingDict = applicationContext["meeting"] as? [String: Any],
           let name = meetingDict["name"] as? String,
           let startDateTimestamp = meetingDict["startDate"] as? TimeInterval,
           let time = meetingDict["time"] as? Int,
           let longitude = meetingDict["longitude"] as? Double,
           let latitude = meetingDict["latitude"] as? Double {

            let receivedMeeting = Meeting(
                name: name,
                startDate: Date(timeIntervalSince1970: startDateTimestamp),
                time: time,
                longitude: longitude,
                latitude: latitude
            )

            Task { @MainActor in
                self.modelContext.insert(receivedMeeting)
                do {
                    try self.modelContext.save()
                } catch {
                    print("Failed to save meeting: \(error)")
                }
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // No-op
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // No-op
    }
}
