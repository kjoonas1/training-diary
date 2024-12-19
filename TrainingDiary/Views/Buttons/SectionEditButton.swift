import SwiftUI
import Inject

struct SectionEditButton: View {
    @Binding var isEditing: Bool
    @ObserveInjection var inject

    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isEditing.toggle()
                }
            }) {
                Image(systemName: isEditing ? "checkmark" : "pencil")
                    .foregroundColor(.white)
                    .frame(width: 32.0, height: 32.0)
                    .background(Circle().fill(isEditing ? .green : .blue))
            }
        }.enableInjection()
    }
}
