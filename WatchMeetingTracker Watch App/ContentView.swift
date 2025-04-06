import SwiftUI
import CoreLocation
import CoreLocationUI
import MapKit
import SwiftData

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var isMeetingActive = false
    @StateObject private var watchConnector = WatchToIphoneConnector()
    @StateObject private var locationManager = LocationManager()

    @State private var region: MapCameraPosition = .automatic
    @State private var meetingStartDate: Date?
    @State private var meetingDuration: TimeInterval = 0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            if isMeetingActive {
                Text("Meeting in progress...")
                    .font(.headline)
                Text("Time: \(formattedDuration())")
                Spacer()
                Button("Finish meeting") {
                    stopMeeting()
                }
            } else {
                Text("Ready to start meeting")
                    .font(.headline)
                Spacer()
                Button("Start new meeting") {
                    startMeeting()
                    locationManager.checkLocationAuthorization()
                }
            }
        }
        .padding()
    }

    private func startMeeting() {
        isMeetingActive = true
        meetingStartDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = meetingStartDate {
                meetingDuration = Date().timeIntervalSince(start)
            }
        }
    }

    private func stopMeeting() {
        guard let startDate = meetingStartDate,
              let coordinate = locationManager.lastKnownLocation else { return }

        let durationInMinutes = Int(meetingDuration / 60)
        let newMeeting = Meeting(
            name: "New Meeting",
            startDate: startDate,
            time: durationInMinutes,
            longitude: coordinate.longitude,
            latitude: coordinate.latitude
        )

        sendToIos(meeting: newMeeting)
        timer?.invalidate()
        timer = nil
        meetingStartDate = nil
        meetingDuration = 0
        isMeetingActive = false
    }

    private func formattedDuration() -> String {
        let duration = Int(meetingDuration)
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func sendToIos(meeting: Meeting) {
        watchConnector.sendMacroToIphone(meeting: meeting)
    }
}

#Preview {
    ContentView()
}
