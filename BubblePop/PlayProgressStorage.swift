import Foundation
import SwiftUI

final class PlayerProgress: ObservableObject {
    @Published var currency: Int { didSet { save() } }
    @Published var selectedBallID: Int { didSet { save() } }
    @Published var selectedBackgroundID: Int { didSet { save() } }

    @Published private(set) var unlockedBallIDs: Set<Int> { didSet { save() } }
    @Published private(set) var unlockedBackgroundIDs: Set<Int> { didSet { save() } }

    // Keyed by GameMode.rawValue (e.g., "normal", "risk", "timeTrial")
    @Published private(set) var highScores: [String: Int] { didSet { save() } }

    private let key = "PLAYER_PROGRESS_v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let d = try? JSONDecoder().decode(Snapshot.self, from: data) {
            self.currency = d.currency
            self.selectedBallID = d.selectedBallID
            self.selectedBackgroundID = d.selectedBackgroundID
            self.unlockedBallIDs = Set(d.unlockedBallIDs)
            self.unlockedBackgroundIDs = Set(d.unlockedBackgroundIDs)
            self.highScores = d.highScores
        } else {
            self.currency = 0
            self.selectedBallID = 0
            self.selectedBackgroundID = 0
            self.unlockedBallIDs = Set(0..<5)        // 5 free balls
            self.unlockedBackgroundIDs = Set(0..<5)  // 5 free backgrounds
            self.highScores = [:]
            save()
        }
    }

    // MARK: - Currency

    func addCurrency(_ amount: Int) { currency = max(0, currency + amount) }

    @discardableResult
    func spendCurrency(_ cost: Int) -> Bool {
        guard currency >= cost else { return false }
        currency -= cost
        return true
    }

    // MARK: - Unlocks

    func isUnlocked(category: ShopCategory, id: Int) -> Bool {
        switch category {
        case .ball: return unlockedBallIDs.contains(id)
        case .background: return unlockedBackgroundIDs.contains(id)
        }
    }

    func unlock(category: ShopCategory, id: Int) {
        switch category {
        case .ball: unlockedBallIDs.insert(id)
        case .background: unlockedBackgroundIDs.insert(id)
        }
    }

    // MARK: - High Scores (per mode)

    func recordHighScore(mode: GameMode, score: Int) {
        let k = mode.rawValue
        let current = highScores[k] ?? 0
        if score > current { highScores[k] = score }
    }

    /// Read the high score for a specific mode.
    func highScore(for mode: GameMode) -> Int {
        highScores[mode.rawValue] ?? 0
    }

    /// Your "primary" high score: Normal mode only.
    var primaryHighScore: Int {
        highScore(for: .normal)
    }

    // MARK: - Persistence

    private func save() {
        let snap = Snapshot(
            currency: currency,
            selectedBallID: selectedBallID,
            selectedBackgroundID: selectedBackgroundID,
            unlockedBallIDs: Array(unlockedBallIDs),
            unlockedBackgroundIDs: Array(unlockedBackgroundIDs),
            highScores: highScores
        )
        if let data = try? JSONEncoder().encode(snap) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private struct Snapshot: Codable {
        var currency: Int
        var selectedBallID: Int
        var selectedBackgroundID: Int
        var unlockedBallIDs: [Int]
        var unlockedBackgroundIDs: [Int]
        var highScores: [String: Int]   // keys == GameMode.rawValue
    }
}
