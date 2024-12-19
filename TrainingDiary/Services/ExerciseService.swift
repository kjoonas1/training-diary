import SwiftUI
import SwiftData

protocol ExerciseServiceProtocol {
    func updateExercise(item: ExerciseSet) -> Void
    func addSection(name: String) -> Void
    func deleteSection(section: Exercise) -> Void
    func deleteItem(item: ExerciseSet) -> Void
    func addExercise(section: Exercise, exercise: ExerciseSet) -> Void
    func deleteAllItems() -> Void
    func deleteItems(offsets: IndexSet) -> Void
}

class ExerciseService: ExerciseServiceProtocol {
    private var modelContext: ModelContext
    @Query private var items: [ExerciseSet]
    @Query private var sections: [Exercise]

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func updateExercise(item: ExerciseSet) {}
    
    func addSection(name: String) {
        let newGroup = Exercise(timestamp: Date(), name: name)
        modelContext.insert(newGroup)
        try? modelContext.save()
    }
    
    func deleteSection(section: Exercise) {
        for set in section.sets {
            modelContext.delete(set)
        }
        modelContext.delete(section)
        try? modelContext.save()
    }
    
    func deleteItem(item: ExerciseSet) {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
    
    
    func addExercise(section: Exercise, exercise: ExerciseSet) {
        withAnimation {
            exercise.group = section
            modelContext.insert(exercise)
            try? modelContext.save()
        }
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
            try? modelContext.save()
        }
    }
    
    func deleteAllItems() {
        withAnimation {
            for item in items {
                modelContext.delete(item)
            }
            for section in sections {
                modelContext.delete(section)
            }
            try? modelContext.save()
        }
    }
}
