import SwiftUI
enum BPBallType: Equatable {
    case normal(Color)
    case red
    case blue
    case gold
    case green
    var label: String? {
        switch self {
            
        case .blue: return "+5"
        case .gold: return "+1"
        case .green: return "+3"
        case .red: return "-1"
        case .normal: return nil
        }
    }
    var color: Color {
        switch self {
        case .normal(let c): return c
        case .red: return .red
        case .blue: return .blue
        case .gold: return .yellow
        case .green: return .green
        }
    }
}

