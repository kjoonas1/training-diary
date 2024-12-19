import SwiftUI
import SwiftData

@main
struct TrainingDiaryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Exercise.self,
            ExerciseSet.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            StackNavigation(diaryView: DiaryView(exerciseService: ExerciseService(modelContext: sharedModelContainer.mainContext)))
        }
        .modelContainer(sharedModelContainer)
    }
}
