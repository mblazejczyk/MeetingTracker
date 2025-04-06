import SwiftUI
import CoreLocation
import CoreLocationUI
import MapKit
import SwiftData
import ActivityKit

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct newMeeting: View {
    @Binding var isPresented: Bool
    @State private var activity: Activity<MeetingAttributes>?
    @StateObject private var locationManager = LocationManager()
    @State private var region: MapCameraPosition = .automatic

    @State private var meetingStartDate: Date?
    @State private var meetingDuration: TimeInterval = 0
    @State private var timer: Timer?

    @Environment(\.modelContext) private var context

    var body: some View {
        HStack {
            Text("New Meeting")
                .font(.title)
                .bold()
                .padding()
            Spacer()
            Button("Cancel") {
                isPresented.toggle()
            }
            .padding()
        }
        .background(Color(.systemGray4))

        VStack {
            if let coordinate = locationManager.lastKnownLocation {
                let location = IdentifiableLocation(coordinate: coordinate)

                Map(position: $region) {
                    Marker("Meeting Location", coordinate: location.coordinate)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onAppear {
                    region = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }

                Text("Latitude: \(coordinate.latitude)")
                Text("Longitude: \(coordinate.longitude)")
                Text("Meeting length: \(formattedDuration())")

                Spacer()

                Button("Finish meeting", action: stopMeeting)
            } else {
                Text("Ready to start meeting")
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
        meetingStartDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = meetingStartDate {
                meetingDuration = Date().timeIntervalSince(start)
            }
        }
        startActivity()
    }

    private func stopMeeting() {
        guard let startDate = meetingStartDate, let coordinate = locationManager.lastKnownLocation else { return }

        let durationInMinutes = Int(meetingDuration / 60)
        let newMeeting = Meeting(
            name: "New Meeting",
            startDate: startDate,
            time: durationInMinutes,
            longitude: coordinate.longitude,
            latitude: coordinate.latitude
        )

        stopActivity()
        context.insert(newMeeting)

        timer?.invalidate()
        timer = nil
        meetingStartDate = nil
        meetingDuration = 0
        isPresented = false
    }

    private func formattedDuration() -> String {
        let duration = Int(meetingDuration)
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func startActivity() {
        let attributes = MeetingAttributes()
        let startTime = Date()
        let state = MeetingAttributes.ContentState(startTime: startTime)
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(60 * 5000))

        do {
            activity = try Activity<MeetingAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Failed to start activity: \(error.localizedDescription)")
        }
    }

    private func stopActivity() {
        guard let activity else { return }

        let updatedState = MeetingAttributes.ContentState(startTime: activity.content.state.startTime)
        let updatedContent = ActivityContent(
            state: updatedState,
            staleDate: Date().addingTimeInterval(60 * 5),
            relevanceScore: 0.0
        )

        Task {
            await activity.end(updatedContent, dismissalPolicy: .immediate)
        }
    }
}

#Preview {
    newMeeting(isPresented: .constant(true))
}
