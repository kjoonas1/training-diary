import Foundation
import SwiftData

@Model
final class Workout {
    @Attribute(.unique) var id: String = UUID().uuidString
    var timestamp: Date
    @Relationship var exercises: [Exercise] = []

    init(id: String = UUID().uuidString, timestamp: Date) {
        self.id = id
        self.timestamp = timestamp
    }
}
