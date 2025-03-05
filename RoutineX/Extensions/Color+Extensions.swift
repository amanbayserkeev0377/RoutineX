import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a,r, g , b) = (255, 142, 142, 147)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String {
        let predefinedColors: [Color: String] = [
                  .red: "FF3B30",
                  .yellow: "FFCC00",
                  .orange: "FF9500",
                  .green: "34C759",
                  .blue: "007AFF",
                  .purple: "AF52DE",
                  .pink: "FF2D55",
                  .gray: "8E8E93",
                  .brown: "964B00"
              ]
              
              if let hex = predefinedColors[self] {
                  return hex
              }
        
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "000000"
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
}
