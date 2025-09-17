import SwiftUI

struct Level: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    /// Target taps required (when nil, free-play goal like “survive”)
    let targetTaps: Int?
    /// Seconds available; nil means “no timer” (survival / 1 life etc.)
    let timeLimit: Int?
    /// Lives provided at start
    let lives: Int
    /// Chance per tick to spawn a red (0…1) – engine scales this
    let redChance: Double
    /// Whether specials (blue/gold/green) are enabled
    let enableSpecials: Bool
    /// Short readable description that we’ll show under the timer
    let blurb: String
}
