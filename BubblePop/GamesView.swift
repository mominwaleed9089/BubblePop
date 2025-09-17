import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var progress: PlayerProgress
    @EnvironmentObject var settings: SettingsStore

    let mode: GameMode
    @StateObject private var engine: GameEngine

    @State private var showPause = false
    @State private var showGameOver = false

    // New: convenience init for time trial with a concrete level
    init(timeTrialLevel: Level) {
        self.mode = .timeTrial
        _engine = StateObject(wrappedValue:
            GameEngine(mode: .timeTrial, selectedBallColor: .blue, level: timeTrialLevel)
        )
    }

    init(mode: GameMode) {
        self.mode = mode
        _engine = StateObject(wrappedValue:
            GameEngine(mode: mode, selectedBallColor: .blue)
        )
    }

    var body: some View {
        ZStack {
            // Background
            Palette.backgroundView(for: progress.selectedBackgroundID)
                .ignoresSafeArea()

            // Capture play area once view lays out
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        // Leave vertical room for HUD and footer
                        let play = geo.frame(in: .local).insetBy(dx: 0, dy: 120)
                        engine.setPlayRect(play)
                    }
            }

            // Balls layer
            ZStack {
                ForEach(engine.balls) { ball in
                    BallView(ball: ball)
                        .position(ball.position)
                        .zIndex(ballZIndex(ball.type))
                        .onTapGesture {
                            // SFX by type
                            switch ball.type {
                            case .normal:
                                AudioManager.shared.playRandomPop(muted: settings.isMuted)
                            case .red:
                                AudioManager.shared.playBomb(muted: settings.isMuted)
                            case .blue:
                                AudioManager.shared.playSwoosh(muted: settings.isMuted)
                            case .green:
                                AudioManager.shared.playTick(muted: settings.isMuted)
                            case .gold:
                                AudioManager.shared.playGold(muted: settings.isMuted)
                            }
                            engine.handleTap(on: ball)
                        }
                }
            }
            .allowsHitTesting(!showPause && !showGameOver)

            // Centered big score
            Text("\(engine.score)")
                .font(.system(size: 56, weight: .black, design: .rounded))
                .shadow(radius: 2)
                .accessibilityLabel("Score \(engine.score)")
                .allowsHitTesting(false)

            // HUD + Challenge text
            VStack(spacing: 4) {
                HUDView(
                    score: engine.score,
                    lives: engine.lives,
                    time: Int(max(0, engine.timeRemaining))
                ) {
                    engine.pauseToggle()
                    showPause = engine.isPaused
                }

                // 👇 Time Trial: show the level blurb right under the timer
                if mode == .timeTrial, let lvl = engine.level {
                    Text(lvl.blurb)
                        .font(.footnote.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                }

                Spacer()
            }

            // ⛔️ Disable back-swipe only in Time Trial
            if mode == .timeTrial {
                Color.clear
                    .background(NavigationSwipeDisabler(disabled: true))
            }
        }
        .navigationBarBackButtonHidden(true)
        // Selected ball color → engine
        .onAppear {
            let color = Palette.ballColors[safe: progress.selectedBallID] ?? .blue
            engine.updateBallColor(color)
        }
        .onChange(of: progress.selectedBallID) { _ in
            let color = Palette.ballColors[safe: progress.selectedBallID] ?? .blue
            engine.updateBallColor(color)
        }
        // Currency awards
        .onReceive(NotificationCenter.default.publisher(for: .awardCurrency)) { note in
            if let amt = note.object as? Int { progress.addCurrency(amt) }
        }
        // Game over → sheet & high score by mode
        .onChange(of: engine.isGameOver) { isOver in
            if isOver {
                showGameOver = true
                progress.recordHighScore(mode: mode, score: engine.score)
            }
        }
        // Pause sheet (no swipe-to-dismiss)
        .sheet(isPresented: $showPause) {
            PauseOverlay(
                resume: {
                    if engine.isPaused { engine.pauseToggle() } // single tap
                    showPause = false
                },
                restart: { restart() },     // ✅ resets timer/lives too
                quit: { quitToMenu() }
            )
            .interactiveDismissDisabled(true)
            .presentationDetents([.fraction(0.35)])
        }
        // Game Over sheet
        .sheet(isPresented: $showGameOver) {
            let key = mode.rawValue
            let currentBest = progress.highScores[key] ?? 0
            let isNew = engine.score > currentBest

            GameOverOverlay(
                score: engine.score,
                livesLeft: engine.lives,
                bonusPerLife: 5,
                isNewHighScore: isNew,         // ⭐ pass the flag
                onReplay: { restart() },
                onMenu:   { quitToMenu() }
            )
            .presentationDetents([.fraction(0.45)])
            .interactiveDismissDisabled(true)
            .onAppear {
                let bonus = engine.lives * 5
                if bonus > 0 { progress.addCurrency(bonus) }
            }
        }

    }

    // MARK: - Actions

    private func restart() {
        let color = Palette.ballColors[safe: progress.selectedBallID] ?? .blue
        engine.updateBallColor(color)
        engine.start()                 // resets score, timer, lives, balls (Time Trial aware)
        showPause = false
        showGameOver = false
    }

    private func quitToMenu() {
        showPause = false
        showGameOver = false
        dismiss()
    }

    private func ballZIndex(_ type: BallType) -> Double {
        switch type {
        case .red: return 3
        case .blue, .gold, .green: return 2
        case .normal: return 1
        }
    }
}
