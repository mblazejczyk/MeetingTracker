import Foundation
import SwiftData

@Model
class Meeting: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var startDate: Date
    var time: Int
    var longitude: Double
    var latitude: Double

    init(name: String, startDate: Date, time: Int, longitude: Double, latitude: Double) {
        self.name = name
        self.startDate = startDate
        self.time = time
        self.longitude = longitude
        self.latitude = latitude
    }
}

