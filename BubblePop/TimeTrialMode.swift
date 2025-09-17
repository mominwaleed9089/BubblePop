import SwiftUI

struct TimeTrialView: View {
@EnvironmentObject var progress: PlayerProgress
@State private var levels: [Level] = LevelGenerator.generate100()
@State private var currentIndex: Int = 0
@State private var engine: GameEngine? = nil
@State private var showCongrats = false

var body: some View {
Group {
if let engine = engine {
TimeTrialGameContainer(engine: engine, onComplete: handleCompletion)
} else {
ProgressView().onAppear { startLevel() }
}
}
.navigationTitle("Level \(levels[currentIndex].id)")
}

private func startLevel() {
let lvl = levels[currentIndex]
let color = Palette.ballColors[safe: progress.selectedBallID] ?? .blue
engine = GameEngine(mode: .timeTrial, selectedBallColor: color, startTime: Double(lvl.timeLimit ?? 60), lives: lvl.lives, level: lvl)
}
    private func handleCompletion(didWin: Bool, score: Int) {
    if didWin {
    progress.addCurrency(2) // reward for a level clear
    if currentIndex < levels.count - 1 {
    currentIndex += 1
    startLevel()
    } else {
    showCongrats = true
    }
    } else {
    startLevel() // replay same level
    }
    }
    }
private struct TimeTrialGameContainer: View {
    @EnvironmentObject var progress: PlayerProgress
    @EnvironmentObject var settings: SettingsStore
    
    @ObservedObject var engine: GameEngine
    var onComplete: (Bool, Int) -> Void
    
    @State private var showPause = false
    @State private var showGameOver = false
    
    var body: some View {
        ZStack {
            Palette.backgroundView(for: progress.selectedBackgroundID)
                .ignoresSafeArea()
            
            GeometryReader { geo in
                Color.clear.onAppear {
                    engine.setPlayRect(geo.frame(in: .local).insetBy(dx: 0, dy: 120))
                }
            }
            
            ZStack {
                ForEach(engine.balls) { ball in
                    BallView(ball: ball)
                        .position(ball.position)
                        .onTapGesture { engine.handleTap(on: ball) }
                }
            }
            VStack {
                HUDView(score: engine.score, lives: engine.lives, time: Int(max(0, engine.timeRemaining))) {
                    engine.pauseToggle(); showPause = engine.isPaused
                }
                Spacer()
            }
        }
        .onChange(of: engine.isGameOver) { isOver in
            if isOver {
                let didWin = engine.level?.targetTaps == 0
                onComplete(didWin, engine.score)
            }
        }
        .sheet(isPresented: $showPause) {
            PauseOverlay(resume: { engine.pauseToggle(); showPause = false },
                         restart: { onComplete(false, engine.score) },
                         quit: { onComplete(false, engine.score) })
            .presentationDetents([.fraction(0.35)])
        }
    }
}
