import Foundation
import SwiftData

@Model
final class ExerciseSet {
    @Attribute(.unique) var id: String = UUID().uuidString
    var timestamp: Date
    var weight: Double
    var count: Int
    var rating: Double
    @Relationship(inverse: \Exercise.sets) var group: Exercise?

    init(id: String = UUID().uuidString, timestamp: Date, weight: Double, count: Int, rating: Double) {
        self.timestamp = timestamp
        self.id = id
        self.weight = weight
        self.count = count
        self.rating = rating
    }
}
