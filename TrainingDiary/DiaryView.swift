import SwiftUI
import SwiftData
import Inject

struct DiaryHeader: View {
    @ObservedObject var viewModel: ExerciseViewModel
    var deleteSection: (Exercise) -> Void
    var section: Exercise
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "figure.disc.sports")
                    .foregroundColor(Color.black)
                Text(section.name)
                    .textCase(.none)
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.deleteSections {
                Button(action: {
                    deleteSection(section)
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .frame(width: 32.0, height: 32.0)
                        .background(Circle().fill(.red))
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: viewModel.deleteSections)
            } else {
                SectionEditButton(isEditing: Binding(
                    get: { viewModel.editingSections[section] ?? false },
                    set: { newValue in
                        viewModel.editingSections[section] = newValue
                        if !newValue {
                            viewModel.editingSections.removeValue(forKey: section)
                        }
                    }
                ))
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: !viewModel.deleteSections)
            }
        }.padding([.bottom], 5)
    }
}

struct DiaryView: View {
    @ObserveInjection var inject
    @Query(sort: \Exercise.name) private var sections: [Exercise]
    @StateObject private var viewModel: ExerciseViewModel
    private var service: ExerciseServiceProtocol
    
    init(exerciseService: ExerciseServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ExerciseViewModel(exerciseService: exerciseService))
        service = exerciseService
    }
    
    var body: some View {
        List {
            ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
                let editing = self.isEditing(section: section)
                
                Section(
                    header: DiaryHeader(viewModel: viewModel, deleteSection: deleteSection, section: section)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                ) {
                    ForEach(section.sets.sorted(by: { $0.timestamp > $1.timestamp })) { item in
                        ExerciseRow(item: item, editing: editing, deleteItem: deleteItem)
                            .padding(.vertical, 5)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                    }
                    .onDelete(perform: { deleteItems(offsets: $0) })
                    .moveDisabled(!editing)
                    .deleteDisabled(!editing)
                    
                    if self.isEditing(section: section) {
                        Button(action: {
                            viewModel.showExerciseModal = true
                            viewModel.addExerciseToSection = section
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .frame(width: 32.0, height: 32.0)
                                    .background(Circle().fill(.green))
                                Spacer()
                                Text("Lisää sarja")
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.vertical, 5)
                        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    }
                }
                .padding(.vertical, 10)
        
                if index < sections.count - 1 {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 1)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding(.vertical, 0)
                        .listRowBackground(Color.clear)
                }
            }
        }
        .environment(\.defaultMinListRowHeight, 0)
        .scrollContentBackground(.hidden)
        .background(Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem {
                Button(action: switchDeleteSection) {
                    HStack {
                        if (!sections.isEmpty) {
                            if (viewModel.deleteSections) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .frame(width: 32.0, height: 32.0)
                                    .background(Circle().fill(.green))
                            } else {
                                Image(systemName: "minus")
                                    .foregroundColor(.white)
                                    .frame(width: 32.0, height: 32.0)
                                    .background(Circle().fill(.red))
                            }
                        } else {
                            Spacer()
                                .frame(width: 32.0, height: 32.0)
                        }
                    }
                }
            }
            ToolbarItem {
                Button(action: { viewModel.showSectionModal = true }) {
                    Label("Add Item", systemImage: "plus")
                }.disabled(viewModel.deleteSections)
            }
        }
        .sheet(isPresented: $viewModel.showSectionModal) {
            NewSectionModal(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showExerciseModal) {
            ExerciseModal(viewModel: viewModel)
        }.enableInjection()
    }
    
    
    private func switchDeleteSection() {
        withAnimation {
            viewModel.deleteSections.toggle()
            viewModel.editingSections.removeAll()
        }
    }
    
    private func deleteSection(section: Exercise) {
        withAnimation {
            service.deleteSection(section: section)
            viewModel.editingSections.removeValue(forKey: section)
            if (sections.isEmpty) {
                viewModel.deleteSections = false
            }
        }
    }
    
    private func deleteItem(item: ExerciseSet) {
        withAnimation {
            service.deleteItem(item: item)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            service.deleteItems(offsets: offsets)
        }
    }
    
    private func isEditing(section: Exercise) -> Bool {
        return viewModel.editingSections[section] == true
    }
}
