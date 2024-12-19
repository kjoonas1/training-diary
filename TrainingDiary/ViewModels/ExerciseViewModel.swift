import SwiftUI
import SwiftData

class ExerciseViewModel: ObservableObject {
    var exerciseService: ExerciseServiceProtocol

    @Published var showSectionModal: Bool = false
    @Published var deleteSections: Bool = false
    @Published var showExerciseModal: Bool = false
    @Published var editingSections: [Exercise: Bool] = [:]
    @Published var addExerciseToSection: Exercise?
    @Published var editingExercise: ExerciseSet?

    init(exerciseService: ExerciseServiceProtocol) {
        self.exerciseService = exerciseService
    }
}
