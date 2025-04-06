import Foundation
import WatchConnectivity

class WatchToIphoneConnector: NSObject, WCSessionDelegate, ObservableObject {
    private var session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        // No-op
    }

    func sendMacroToIphone(meeting: Meeting) {
        guard session.isReachable else {
            print("iPhone session unreachable")
            return
        }

        let meetingDict: [String: Any] = [
            "name": meeting.name,
            "startDate": meeting.startDate.timeIntervalSince1970,
            "time": meeting.time,
            "longitude": meeting.longitude,
            "latitude": meeting.latitude
        ]

        do {
            try session.updateApplicationContext(["meeting": meetingDict])
            print("Meeting data sent to iPhone")
        } catch {
            print("Failed to send meeting data: \(error.localizedDescription)")
        }
    }
}
