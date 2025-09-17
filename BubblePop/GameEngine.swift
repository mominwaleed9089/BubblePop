import SwiftUI
import Combine

// MARK: - Model

struct Ball: Identifiable {
    let id = UUID()
    let type: BallType
    var position: CGPoint
    let expiry: Date?      // nil = persistent (no despawn)
    var despawns: Bool
}

// MARK: - Engine

final class GameEngine: ObservableObject {
    // Inputs
    let mode: GameMode
    @Published var selectedBallColor: Color

    // State
    @Published var balls: [Ball] = []
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var timeRemaining: Double = 60
    @Published var isPaused: Bool = false
    @Published var isGameOver: Bool = false

    // Currency pacing
    private var tapsCountForCurrency = 0
    private let tapsPerCurrencyNormal = 4
    private let tapsPerCurrencyRisk = 10

    // Timer
    private var tickCancellable: AnyCancellable?

    // Layout / bounds
    private var playRect: CGRect = .zero
    private let bubbleRadius: CGFloat = 42            // BallView circle ~84 → r=42
    private let innerMargin: CGFloat = 52             // keep away from edges
    private let minSeparation: CGFloat = 42 * 2 + 6   // avoid overlap

    // Tap forgiveness window for despawning balls
    private let despawnGrace: TimeInterval = 0.20

    // Avoid the visual center where score/timer overlay sits
    private var uiCenter: CGPoint { CGPoint(x: playRect.midX, y: playRect.midY) }
    private let uiExclusionRadius: CGFloat = 90

    // Time Trial
    var level: Level?
    private var targetTaps: Int = 0   // << non-optional now

    // Restart helpers so timer/lives reset properly
    private let initialStartTime: Double
    private let initialLives: Int

    // MARK: Init

    init(mode: GameMode,
         selectedBallColor: Color,
         startTime: Double = 60,
         lives: Int = 3,
         level: Level? = nil)
    {
        self.mode = mode
        self.selectedBallColor = selectedBallColor
        self.level = level

        if let lvl = level {
            // Safely unwrap optionals with sensible defaults
            if let t = lvl.timeLimit {
                self.timeRemaining = Double(t)
            } else {
                // No timer level (survival-style)
                self.timeRemaining = 60
            }
            self.lives = lvl.lives
            self.targetTaps = lvl.targetTaps ?? 0

            self.initialStartTime = Double(lvl.timeLimit ?? 60)
            self.initialLives = lvl.lives
        } else {
            self.timeRemaining = startTime
            self.lives = lives
            self.targetTaps = 0

            self.initialStartTime = startTime
            self.initialLives = lives
        }

        start()
    }

    // MARK: Public API

    func updateBallColor(_ color: Color) { selectedBallColor = color }
    func setPlayRect(_ rect: CGRect) { playRect = rect }

    func start() {
        isGameOver = false
        isPaused = false
        score = 0
        balls.removeAll()
        tapsCountForCurrency = 0

        // Reset lives/time from level if present (safe unwrap)
        if let lvl = level {
            lives = lvl.lives
            timeRemaining = Double(lvl.timeLimit ?? Int(initialStartTime))
            targetTaps = lvl.targetTaps ?? 0
        } else {
            lives = initialLives
            timeRemaining = initialStartTime
            targetTaps = 0
        }

        tickCancellable?.cancel()
        tickCancellable = Timer.publish(every: 0.016, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick() }
    }

    func pauseToggle() { isPaused.toggle() }

    // MARK: Tick Loop

    private func tick() {
        guard !isPaused, !isGameOver else { return }

        // Timer (unless timeTrial with no timeLimit set)
        if level?.timeLimit != nil || mode != .timeTrial {
            timeRemaining -= 0.016
            if timeRemaining <= 0 { endGame() }
        }

        // Despawn ephemeral balls (with grace window)
        let now = Date()
        balls.removeAll { b in
            guard b.despawns, let exp = b.expiry else { return false }
            return exp.addingTimeInterval(despawnGrace) < now
        }

        switch mode {
        case .normal:
            if !hasNormalBall { spawnNormalPersistent() }
            if !hasRedBall, chance(0.006) {
                spawn(.red,
                      life: Double.random(in: 0.80...1.05),
                      despawns: true,
                      avoidNormal: true,
                      avoidCenter: true,
                      avoidOthers: true)
            }

        case .risk:
            if !hasNormalBall { spawnNormalPersistent() }
            if !hasRedBall, chance(0.007) {
                spawn(.red,
                      life: Double.random(in: 0.80...1.10),
                      despawns: true,
                      avoidNormal: true,
                      avoidCenter: true,
                      avoidOthers: true)
            }
            if !hasGoldBall, lives < 3, chance(0.005) {
                spawn(.gold,
                      life: Double.random(in: 0.55...0.75),
                      despawns: true,
                      avoidNormal: true,
                      avoidCenter: true,
                      avoidOthers: true)
            }
            if !hasBlueBall, chance(0.010) {
                spawn(.blue,
                      life: Double.random(in: 0.45...0.65),
                      despawns: true,
                      avoidNormal: true,
                      avoidCenter: true,
                      avoidOthers: true)
            }
            if !hasGreenBall, chance(0.010) {
                spawn(.green,
                      life: Double.random(in: 0.60...0.90),
                      despawns: true,
                      avoidNormal: true,
                      avoidCenter: true,
                      avoidOthers: true)
            }

        case .timeTrial:
            if !hasNormalBall { spawnNormalPersistent() }

            // Per-level red frequency
            let base = level?.redChance ?? 0.08
            if !hasRedBall, chance(max(0.003, base * 0.25)) {
                spawn(.red,
                      life: Double.random(in: 0.65...0.85),
                      despawns: true,
                      avoidNormal: true,
                      avoidCenter: true,
                      avoidOthers: true)
            }

            // Enable specials only if the level allows
            if level?.enableSpecials == true {
                if !hasBlueBall, chance(0.010) {
                    spawn(.blue,
                          life: Double.random(in: 0.45...0.65),
                          despawns: true,
                          avoidNormal: true,
                          avoidCenter: true,
                          avoidOthers: true)
                }
                if !hasGreenBall, chance(0.010) {
                    spawn(.green,
                          life: Double.random(in: 0.60...0.90),
                          despawns: true,
                          avoidNormal: true,
                          avoidCenter: true,
                          avoidOthers: true)
                }
                if !hasGoldBall, lives < 3, chance(0.005) {
                    spawn(.gold,
                          life: Double.random(in: 0.55...0.75),
                          despawns: true,
                          avoidNormal: true,
                          avoidCenter: true,
                          avoidOthers: true)
                }
            }
        }
    }

    // MARK: Spawn helpers

    private var hasNormalBall: Bool {
        balls.contains { if case .normal(_) = $0.type { return true } else { return false } }
    }
    private var hasRedBall: Bool {
        balls.contains { if case .red = $0.type { return true } else { return false } }
    }
    private var hasBlueBall: Bool {
        balls.contains { if case .blue = $0.type { return true } else { return false } }
    }
    private var hasGreenBall: Bool {
        balls.contains { if case .green = $0.type { return true } else { return false } }
    }
    private var hasGoldBall: Bool {
        balls.contains { if case .gold = $0.type { return true } else { return false } }
    }

    private func spawnNormalPersistent() {
        spawn(.normal(selectedBallColor),
              life: 999,
              despawns: false,
              avoidNormal: false,
              avoidCenter: false,
              avoidOthers: true)
    }

    private func chance(_ p: Double) -> Bool { Double.random(in: 0...1) < p }

    /// Main spawn that enforces edge margin, center avoidance, and separation.
    private func spawn(_ type: BallType,
                       life: Double,
                       despawns: Bool,
                       avoidNormal: Bool,
                       avoidCenter: Bool,
                       avoidOthers: Bool)
    {
        guard playRect.width > 0 else { return }

        let maxTries = 28
        let normalCenter = balls.first { if case .normal(_) = $0.type { return true } else { return false } }?.position

        for _ in 0..<maxTries {
            let x = CGFloat.random(in: (playRect.minX + innerMargin)...(playRect.maxX - innerMargin))
            let y = CGFloat.random(in: (playRect.minY + innerMargin)...(playRect.maxY - innerMargin))
            let p = CGPoint(x: x, y: y)

            if avoidCenter, hypot(p.x - uiCenter.x, p.y - uiCenter.y) < uiExclusionRadius {
                continue
            }
            if avoidNormal, let nc = normalCenter, hypot(p.x - nc.x, p.y - nc.y) < minSeparation {
                continue
            }
            if avoidOthers {
                var collides = false
                for b in balls {
                    let d = hypot(p.x - b.position.x, p.y - b.position.y)
                    if d < minSeparation {
                        collides = true
                        break
                    }
                }
                if collides { continue }
            }

            let expiry = despawns ? Date().addingTimeInterval(life) : nil
            balls.append(Ball(type: type, position: p, expiry: expiry, despawns: despawns))
            break
        }
    }

    // MARK: Input

    func handleTap(on ball: Ball) {
        guard !isGameOver else { return }

        // Remove tapped ball
        balls.removeAll { $0.id == ball.id }

        switch ball.type {
        case .normal:
            score += 1
            if mode == .normal {
                awardCurrencyIfNeeded(threshold: tapsPerCurrencyNormal)
            } else if mode == .risk {
                awardCurrencyIfNeeded(threshold: tapsPerCurrencyRisk)
            }
            if mode == .timeTrial {
                targetTaps = max(0, targetTaps - 1)
                if targetTaps == 0 { endGame(didWin: true) }
            }

        case .red:
            lives -= 1
            if lives <= 0 { endGame() }

        case .blue:
            score += 5

        case .gold:
            if lives < 3 { lives += 1 }

        case .green:
            timeRemaining += 3
        }
    }

    // MARK: Currency

    private func awardCurrencyIfNeeded(threshold: Int) {
        tapsCountForCurrency += 1
        if tapsCountForCurrency >= threshold {
            NotificationCenter.default.post(name: .awardCurrency, object: 1)
            tapsCountForCurrency = 0
        }
    }

    // MARK: End

    private func endGame(didWin: Bool = false) {
        isGameOver = true
    }
}
