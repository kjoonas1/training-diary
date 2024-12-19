import SwiftUI
import Inject

struct ExerciseModal: View {
    @ObserveInjection var inject

    @ObservedObject var viewModel: ExerciseViewModel
    @State private var weight: String = ""
    @State private var count: String = ""
    @State private var exerciseRating: Double = 5.0
    
    var body: some View {
        let exercise = viewModel.editingExercise
        let section = viewModel.addExerciseToSection
        
        NavigationView {
            Form {
                Section(header: Text("Sarjan tiedot")) {
                    TextField("Paino (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                    TextField("Toistoja", text: $count)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled()
                }
                Section(header: Text("Fiilis")) {
                    HStack {
                        Text("\(Int(exerciseRating))")
                        Slider(value: $exerciseRating, in: 1...10, step: 1)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitle(exercise == nil ? "Lisää sarja" : "Muokkaa sarjaa", displayMode: .inline)
            .navigationBarItems(leading: Button("Peruuta") {
                viewModel.showExerciseModal = false
            }, trailing: Button(exercise == nil ? "Lisää" : "Tallenna") {
                guard let weightValue = Double(weight.replacing(",", with: ".")),
                      let countValue = Int(count),
                      let section = section else { return }
                
                let newExercise = ExerciseSet(timestamp: Date(), weight: weightValue, count: countValue, rating: exerciseRating)
                
                if let existingExercise = exercise {
                    withAnimation {
                        viewModel.exerciseService.updateExercise(item: existingExercise)
                    }
                } else {
                    withAnimation {
                        viewModel.exerciseService.addExercise(section: section, exercise: newExercise)
                    }
                }
                
                viewModel.showExerciseModal = false
            })
        }
        .onAppear {
            if let exercise = exercise {
                weight = "\(exercise.weight)"
                count = "\(exercise.count)"
            }
        }
        .enableInjection()
    }
}
