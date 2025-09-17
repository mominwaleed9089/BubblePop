import SwiftUI
import UIKit

enum Palette {
    // MARK: - Balls (solids / neons / glossy)
    static let ballColors: [Color] = [
        // SOLIDS (0...7)
        Color(hex: 0xFF4D4D), Color(hex: 0xFF8A00), Color(hex: 0xFFC800), Color(hex: 0x33DD55),
        Color(hex: 0x00C2FF), Color(hex: 0x5A7DFF), Color(hex: 0xC167FF), Color(hex: 0xFF4DC4),
        // NEONS (8...17)
        Color(hex: 0x00FFC8), Color(hex: 0x66FF66), Color(hex: 0x66B3FF), Color(hex: 0xFF66B3),
        Color(hex: 0xFFD166), Color(hex: 0x9A66FF), Color(hex: 0x66FFE3), Color(hex: 0xE666FF),
        Color(hex: 0x88FF44), Color(hex: 0x44FFD5),
        // GLOSSY (18...24)
        Color(hex: 0xFF7A7A), Color(hex: 0xFFB36B), Color(hex: 0xFFE56B), Color(hex: 0x7AE58F),
        Color(hex: 0x6FD7FF), Color(hex: 0x7F9BFF), Color(hex: 0xD98CFF)
    ]

    enum BallRenderStyle { case solid, neon, glossy }

    static func ballStyle(for id: Int) -> BallRenderStyle {
        switch id {
        case 0...7:   return .solid
        case 8...17:  return .neon
        default:      return .glossy
        }
    }

    // MARK: - Backgrounds (solids + gradients)
    // MARK: - Backgrounds (solids + distinct gradients)
    enum BackgroundStyle {
        case color(Color)
        case linear(Color, Color)
    }

    static let backgroundsStyles: [BackgroundStyle] = [
        // 🔹 BASIC SOLIDS (0...7)
        .color(.white),                      // 0
        .color(.black),                      // 1
        .color(.gray),                       // 2
        .color(.blue),                       // 3
        .color(.green),                      // 4
        .color(.red),                        // 5
        .color(.orange),                     // 6
        .color(.purple),                     // 7

        // 🔹 SOFT LIGHT SOLIDS (8...11)
        .color(Color(hex: 0xF6F7FB)),        // 8 mist
        .color(Color(hex: 0xFFF3E9)),        // 9 peach milk
        .color(Color(hex: 0xECFFF3)),        // 10 mint foam
        .color(Color(hex: 0xE8F6FF)),        // 11 sky milk

        // 🔹 DARK SOLIDS (12...17)
        .color(Color(hex: 0x1C1C1E)),        // 12 iOS dark gray
        .color(Color(hex: 0x2C2C54)),        // 13 midnight blue
        .color(Color(hex: 0x3B2E5A)),        // 14 deep violet
        .color(Color(hex: 0x252525)),        // 15 charcoal
        .color(Color(hex: 0x4E342E)),        // 16 dark brown
        .color(Color(hex: 0x0D47A1)),        // 17 navy

        // 🔹 DISTINCT GENTLE GRADIENTS (18...23)
        .linear(Color(hex: 0xE3F2FF), Color(hex: 0xE3FFE9)), // 18 sky → mint
        .linear(Color(hex: 0xFFF2DA), Color(hex: 0xFFE0FF)), // 19 cream → pink
        .linear(Color(hex: 0xE6E5FF), Color(hex: 0xDFFCF1)), // 20 periwinkle → aqua
        .linear(Color(hex: 0xFFE7E0), Color(hex: 0xE0F0FF)), // 21 coral → ice blue
        .linear(Color(hex: 0xECFFF8), Color(hex: 0xF1E6FF)), // 22 seafoam → lavender
        .linear(Color(hex: 0xFFF5DC), Color(hex: 0xDCF1FF)), // 23 butter → frost

        // 🔹 DARK GRADIENTS (24...30)
        .linear(Color(hex: 0x141E30), Color(hex: 0x243B55)), // 24 deep blue dusk
        .linear(Color(hex: 0x232526), Color(hex: 0x414345)), // 25 steel gray
        .linear(Color(hex: 0x0F2027), Color(hex: 0x203A43)), // 26 night teal
        .linear(Color(hex: 0x2C3E50), Color(hex: 0x4CA1AF)), // 27 blue steel
        .linear(Color(hex: 0x42275A), Color(hex: 0x734B6D)), // 28 plum dusk
        .linear(Color(hex: 0x141414), Color(hex: 0x434343)), // 29 onyx
        .linear(Color(hex: 0x000428), Color(hex: 0x004E92))  // 30 midnight → ocean
    ]


    // ✅ FULL-SCREEN BACKGROUND for GameView/RootView
    @ViewBuilder
    static func backgroundView(for id: Int) -> some View {
        let style = bgStyle(at: id)
        switch style {
        case .color(let c):
            c
        case .linear(let a, let b):
            LinearGradient(colors: [a, b], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    // ✅ SWATCH for Achievements grid
    @ViewBuilder
    static func backgroundSwatch(for id: Int, cornerRadius: CGFloat = 14) -> some View {
        let style = bgStyle(at: id)
        switch style {
        case .color(let c):
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(c)
        case .linear(let a, let b):
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(LinearGradient(colors: [a, b],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
        }
    }

    // MARK: - Helpers
    private static func bgStyle(at id: Int) -> BackgroundStyle {
        if id >= 0 && id < backgroundsStyles.count {
            return backgroundsStyles[id]
        } else {
            return .color(Color(white: 0.96))
        }
    }
}

// MARK: - Utilities

// If you already have this elsewhere, delete this copy to avoid "invalid redeclaration".
extension Array {
    subscript(safe i: Int) -> Element? { (i >= 0 && i < count) ? self[i] : nil }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(red: r, green: g, blue: b).opacity(alpha)
    }

    func lighten(_ amt: Double) -> Color {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(
            red: min(Double(r) + amt, 1),
            green: min(Double(g) + amt, 1),
            blue: min(Double(b) + amt, 1)
        )
    }
}
