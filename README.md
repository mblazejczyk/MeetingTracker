# MeetingTracker

MeetingTracker is a lightweight Swift-based iOS and watchOS application for tracking in-person meetings. It allows users to log the duration, time, and precise location of their meetings. The data is stored using SwiftData and visualized via a simple interface. The app supports Live Activities and Apple Watch communication using WatchConnectivity.

## Features

- 🕒 Start and stop meetings on iPhone or Apple Watch
- 📍 Capture GPS coordinates (latitude & longitude)
- ⏱️ Track and display meeting duration
- 🧭 Display real-time location using MapKit
- 📤 Sync data between Apple Watch and iPhone
- 🧩 Live Activity support with Dynamic Island integration
- 🗂️ Store meetings using SwiftData

## Project Structure

| **File**                      | **Description** |
|------------------------------|-----------------|
| `Meeting.swift`              | Defines the main data model used across the app |
| `newMeeting.swift`           | Handles the user interface for starting and stopping meetings on iPhone, recording the start time, tracking duration, and saving meeting data to SwiftData. |
| `LocationManager.swift`      | Manages user location authorization and provides real-time updates using `CLLocationManager`. Publishes the user's last known coordinate. |
| `MeetingDetails.swift`       | Displays detailed information about individual meeting records including duration and geographic location. |
| `WatchConnector.swift`       | Handles communication from the iPhone side, receiving data from the Apple Watch and inserting it into the SwiftData model context. |
| `WatchToIphoneConnector.swift` | Handles communication from the Watch side, sending meeting data to the paired iPhone using `updateApplicationContext()`. |
| `ContentView.swift` (iPhone) | Shows main interface of app and list of saved meetings. |
| `ContentView.swift` (watchOS)| Provides the interface on Apple Watch to start and end meetings, using timers and location updates, then synchronizes the data with the iPhone. |
| `MeetingWidget.swift`        | Handles the display of Live Activities and Dynamic Island content. |



## Technologies Used
- Swift & SwiftUI
- SwiftData
- CoreLocation
- MapKit
- WatchConnectivity
- WidgetKit & ActivityKit

## Getting Started

### Prerequisites
- Xcode 15+
- iOS 17+
- Apple Watch with watchOS 10+

### Installation
1. Clone the repo
2. Open `MeetingTracker.xcodeproj`
3. Add needed permitions to MapKit and frameworks (LiveActivity)
4. Run the app on your iPhone and Watch simulator/device

### Usage
- Launch the app on your iPhone and Apple Watch
- Start and end meetings from either device
- View your meeting history and durations
- Check Live Activity status via the Dynamic Island (if supported)

## Author & thanks
Made by Mateusz Błażejczyk <br>
Thanks to the idea of my thesis supervisor, Miłosz
