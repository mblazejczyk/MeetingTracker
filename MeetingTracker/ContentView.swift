import SwiftUI
import SwiftData

struct ContentView: View {
    @MainActor
    @Query private var meetings: [Meeting]
    @Environment(\.modelContext) private var context

    @State private var showNewMeetingView = false
    @State private var responded = ""
    @State private var showResponse = false

    var body: some View {
        let watchConnector = WatchConnector(modelContext: context)

        VStack {
            HStack {
                Text("Meeting tracker")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: { showNewMeetingView.toggle() }) {
                    Text("New")
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green)
                        )
                }
            }
            .padding()
            .fullScreenCover(isPresented: $showNewMeetingView) {
                newMeeting(isPresented: $showNewMeetingView)
            }
            .onAppear {
                watchConnector.session.activate()
            }

            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(meetings) { meeting in
                            NavigationLink(destination: meetingDetails(id: meeting.id)) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(meeting.name)
                                            .bold()
                                            .font(.title2)
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                    }
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(meeting.startDate, style: .date)
                                            Text(meeting.startDate, style: .time)
                                        }
                                        .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray4))
                                )
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                    .padding()
                }
            }
        }
        .alert("New name", isPresented: $showResponse) {
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text(responded)
        }
    }

    func getWatch() {
        print("test")
        showResponse.toggle()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Meeting.self, inMemory: true)
}
