import SwiftUI
import Inject

struct NewSectionModal: View {
    @ObserveInjection var inject

    @ObservedObject var viewModel: ExerciseViewModel
    @State private var newSectionName: String = ""
    
    // Example predefined variations
    private let predefinedSections = ["Penkki", "Kyykky", "Maastaveto", "Kulmasoutu", "Leuanveto"]

    var body: some View {
        NavigationView {
            Form {
                // Predefined variations section
                Section(header: Text("Valitse liike")) {
                    ForEach(predefinedSections, id: \.self) { section in
                        Button(section) {
                            withAnimation {
                                viewModel.exerciseService.addSection(name: section)
                                viewModel.showSectionModal = false
                                newSectionName = ""
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }

                // TextField for manual input
                Section {
                    TextField("Liikkeen nimi", text: $newSectionName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                }
            }
            .navigationBarTitle("Lisää uusi liike", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    withAnimation {
                        viewModel.showSectionModal = false
                        newSectionName = ""
                    }
                },
                trailing: Button("Add") {
                    withAnimation {
                        viewModel.exerciseService.addSection(name: newSectionName)
                        viewModel.showSectionModal = false
                        newSectionName = ""
                    }
                }
            )
        }
        .enableInjection()
    }
}
