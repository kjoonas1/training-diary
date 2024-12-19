import SwiftUI

extension Color {
    func interpolate(to color: Color, fraction: Double) -> Color {
        let fraction = min(max(0, fraction), 1) // Clamp fraction between 0 and 1
        
        let startComponents = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        let endComponents = UIColor(color).cgColor.components ?? [0, 0, 0, 1]
        
        let r = startComponents[0] + fraction * (endComponents[0] - startComponents[0])
        let g = startComponents[1] + fraction * (endComponents[1] - startComponents[1])
        let b = startComponents[2] + fraction * (endComponents[2] - startComponents[2])
        let a = startComponents[3] + fraction * (endComponents[3] - startComponents[3])
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
}
