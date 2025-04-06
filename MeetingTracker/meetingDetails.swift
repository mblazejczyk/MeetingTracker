import SwiftUI
import MapKit
import SwiftData

struct meetingDetails: View {
    let id: UUID

    @Environment(\.modelContext) private var context
    @State private var meeting: Meeting?
    @State private var region: MapCameraPosition = .automatic
    @State private var showAlert = false
    @State private var newName = ""

    var body: some View {
        VStack {
            if let meeting = meeting {
                let coordinate = CLLocationCoordinate2D(latitude: meeting.latitude, longitude: meeting.longitude)

                Button(action: { showAlert.toggle() }) {
                    Text(meeting.name)
                        .font(.title)
                }

                Map(position: $region) {
                    Marker("Meeting Location", coordinate: coordinate)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onAppear {
                    region = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }

                Button(action: {
                    openInAppleMaps(latitude: meeting.latitude, longitude: meeting.longitude, name: meeting.name)
                }) {
                    Text("Open in Apple Maps")
                        .font(.headline)
                        .foregroundColor(.blue)
                }

                Text("Meeting date: \(meeting.startDate, style: .date) \(meeting.startDate, style: .time)")
                Text("Meeting time: \(formattedDuration(meeting.time))")

                Spacer()

                Button(action: deleteMeeting) {
                    Text("Delete meeting")
                }
            } else {
                Text("Loading meeting details...")
                    .onAppear(perform: fetchMeeting)
            }
        }
        .padding()
        .alert("New name", isPresented: $showAlert) {
            TextField("Name", text: $newName)
            Button("Set", action: changeName)
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("Please provide new name.")
        }
    }

    private func fetchMeeting() {
        let fetchRequest = FetchDescriptor<Meeting>(predicate: #Predicate { $0.id == id })
        do {
            meeting = try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching meeting: \(error)")
        }
    }

    private func formattedDuration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return "\(hours)h \(remainingMinutes)m"
    }

    private func changeName() {
        guard let meeting, !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        meeting.name = newName
        do {
            try context.save()
        } catch {
            print("Error saving updated name: \(error)")
        }
    }

    private func deleteMeeting() {
        guard let meeting else { return }

        context.delete(meeting)
        do {
            try context.save()
        } catch {
            print("Error deleting meeting: \(error)")
        }
    }

    private func openInAppleMaps(latitude: Double, longitude: Double, name: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Location"
        if let url = URL(string: "http://maps.apple.com/?q=\(encodedName)&ll=\(latitude),\(longitude)&t=m") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    meetingDetails(id: UUID())
}
