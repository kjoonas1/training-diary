import SwiftUI
import Inject

struct ExerciseRow: View {
    @ObserveInjection var inject

    var item: ExerciseSet
    var editing: Bool
    var deleteItem: (ExerciseSet) -> Void

    private var ratingColor: Color {
        switch item.rating {
        case ..<5:
            // Interpolate from red to yellow
            let normalizedRating = Double(item.rating) / 5.0 // Scale to 0-1 range
            return Color.red.interpolate(to: .yellow, fraction: normalizedRating)
        case 5...10:
            // Interpolate from yellow to green
            let normalizedRating = (Double(item.rating) - 5) / 5.0 // Scale to 0-1 range
            return Color.yellow.interpolate(to: .green, fraction: normalizedRating)
        default:
            return .gray
        }
    }
    
    private func formattedWeight(_ weight: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "fi_FI")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: weight)) ?? "\(weight)"
    }

    var body: some View {
        HStack {
            Text("\(item.count) toistoa")
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(formattedWeight(item.weight)) kg")
                .frame(alignment: .trailing)
        }
        .listRowBackground(ratingColor.opacity(0.2))
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
        .padding(.horizontal, 10)
        .swipeActions(edge: .trailing) {
            if editing {
                Button(role: .destructive) {
                    deleteItem(item)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }.enableInjection()
    }
}
