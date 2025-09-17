import Foundation
enum GameMode: String, CaseIterable, Identifiable {
    case normal = "Normal"
    case risk = "Risk+"
    case timeTrial = "Time Trial"
    var id: String { rawValue }
}
