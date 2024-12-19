import Foundation
import SwiftData

@Model
final class Exercise {
    @Attribute(.unique) var id: String = UUID().uuidString
    var timestamp: Date
    @Relationship var sets: [ExerciseSet] = []
    var name: String

    init(id: String = UUID().uuidString, timestamp: Date, name: String) {
        self.id = id
        self.timestamp = timestamp
        self.name = name
    }
}
