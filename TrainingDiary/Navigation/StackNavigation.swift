import SwiftUI
import Inject

struct StackNavigation<DiaryView: View>: View {
    @ObserveInjection var inject

    @State private var path = NavigationPath() // Track navigation path
    let diaryView: DiaryView

    var body: some View {
        NavigationStack(path: $path) {
            MenuView() // Main menu view
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .diary:
                        diaryView.navigationTitle("Diary")
                    }
                }
                .navigationTitle("Training buddy") // Set title for the main menu
        }.enableInjection()
    }
}

enum Destination: Hashable {
    case diary
}

struct MenuView: View {
    var body: some View {
        List {
            NavigationLink("Training Diary", value: Destination.diary)
        }
    }
}
