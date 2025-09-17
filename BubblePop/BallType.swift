import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum BallType {
    case normal(Color)// user-selected color
    case red            // -1 life
    case blue           // +5 score
    case gold           // +1 life (if < 3)
    case green          // +3 seconds
}

extension BallType {
    /// Background color of the bubble
    var color: Color {
        switch self {
        case .normal(let c): return c
        case .red:   return .red
        case .blue:  return .blue
        case .gold:  return Color.yellow.opacity(0.85)
        case .green: return .green
        }
    }

    /// SF Symbol to show inside the bubble
    var symbolName: String? {
        switch self {
        case .normal: return nil
        case .blue:   return "arrow.up"
        case .green:  return "clock.fill"
        case .gold:   return "heart.fill"
        case .red:
            #if canImport(UIKit)
            if UIImage(systemName: "bomb.fill") != nil { return "bomb.fill" }
            #endif
            return "exclamationmark.octagon.fill"
        }
    }

    /// Tint for the symbol
    var symbolTint: Color? {
        switch self {
        case .gold:  return .yellow
        case .red, .blue, .green: return .white
        case .normal: return nil
        }
    }
}

