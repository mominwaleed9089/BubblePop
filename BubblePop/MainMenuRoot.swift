import SwiftUI

struct RootView: View {
    @EnvironmentObject var progress: PlayerProgress
    @EnvironmentObject var settings: SettingsStore

    @State private var showModes = false
    @State private var showShop  = false

    // NEW: sheets for info/help
    @State private var showInfo  = false   // bottom-left
    @State private var showHelp  = false   // bottom-right

    var body: some View {
        NavigationStack {
            ZStack {
                // Animated background
                BubbleBackground()
                    .ignoresSafeArea()

                VStack(spacing: 22) {
                    Spacer(minLength: 24)

                    // Title + High Score
                    VStack(spacing: 6) {
                        Text("BubblePop")
                            .font(.system(size: 44, weight: .black, design: .rounded))
                            .shadow(radius: 2)

                        Text("High Score: \(bestScore())")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }

                    // Main actions
                    VStack(spacing: 14) {
                        BigMenuButton(title: "Choose Mode", systemImage: "play.fill") {
                            showModes = true
                        }
                        BigMenuButton(title: "Achievements", systemImage: "star.fill") {
                            showShop = true
                        }
                    }
                    .padding(.top, 8)

                    Spacer()

                    // Rotating tip
                    TipRotator(tips: [
                        "Tap the main bubble to score points!",
                        "Avoid the red bomb — it costs a life.",
                        "Blue arrow = +5 points. Grab it quick!",
                        "Green clock adds +3 seconds to your timer.",
                        "Gold heart restores a life if you’re under 3.",
                        "Earn stars to unlock new balls & backgrounds.",
                        "High scores are saved by game mode.",
                        "Muted? Tap the speaker icon to toggle sound.",
                        "Score builds faster with streaks of taps.",
                        "Experiment with different ball styles — neon looks awesome!",
                        "Every background changes the vibe — unlock them all!"
                    ])
                    .frame(maxWidth: 280)              // shrink to fit between icons
                    .padding(.bottom, 60)

                    .padding(.bottom, 24)
                }

                // Top-right: currency + mute
                VStack {
                    HStack(spacing: 12) {
                        CurrencyPill(amount: progress.currency)
                        Button {
                            withAnimation(.spring(response: 0.60, dampingFraction: 0.90)) {
                                settings.isMuted.toggle()
                            }
                        } label: {
                            Image(systemName: settings.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                .font(.title3)
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .accessibilityLabel("Toggle Sound")
                    }
                    .padding(.top, 18)
                    .padding(.trailing, 18)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                // NEW: bottom info/help buttons
                VStack {
                    Spacer()
                    HStack {
                        // Bottom-left: About (what the game is + support)
                        CircularFooterButton(
                            systemImage: "info.circle",
                            label: "Info",
                            action: { showInfo = true }
                        )

                        Spacer()

                        // Bottom-right: How to Play (basic controls/tips)
                        CircularFooterButton(
                            systemImage: "questionmark.circle",
                            label: "How to Play",
                            action: { showHelp = true }
                        )
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 22)
                }
            }
            // Navigation
            .navigationDestination(isPresented: $showModes) { ModeSelectView() }
            .navigationDestination(isPresented: $showShop)  { AchievementsShopView() }
            .navigationBarHidden(true)

            // NEW: Sheets
            .sheet(isPresented: $showInfo) {
                InfoSheet()
                    .presentationDetents([.fraction(0.45)])
            }
            .sheet(isPresented: $showHelp) {
                HowToPlaySheet()
                    .presentationDetents([.fraction(0.50)])
            }
        }
    }

    // Prefer Normal as headline; fallback to any max.
    private func bestScore() -> Int {
        let normalKey = GameMode.normal.rawValue
        if let s = progress.highScores[normalKey] { return s }
        return progress.highScores.values.max() ?? 0
    }
}

// MARK: - Footer Button (Apple-style circular icon + tiny label)

private struct CircularFooterButton: View {
    let systemImage: String
    let label: String
    var action: () -> Void

    @State private var pressed = false

    var body: some View {
        VStack(spacing: 6) {
            Button {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) { pressed = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    pressed = false
                    action()
                }
            } label: {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().stroke(.white.opacity(0.22), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                    .scaleEffect(pressed ? 0.94 : 1.0)
            }
            .buttonStyle(.plain)

            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
    }
}

// MARK: - Info Sheet (About + Support email)

private struct InfoSheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                Text("About BubblePop")
                    .font(.title2.bold())
            }

            Text("BubblePop is a fast, kid-friendly tap game. Collect points by popping bubbles, avoid the red bomb, and unlock new looks with the stars you earn.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider().padding(.vertical, 4)

            HStack(spacing: 10) {
                Image(systemName: "envelope.fill")
                Link("Support: mominwaleed9089@gmail.com",
                     destination: URL(string: "mailto:mominwaleed9089@gmail.com")!)
                    .font(.callout.weight(.semibold))
            }

            Spacer()
        }
        .padding(20)
    }
}

// MARK: - How To Play Sheet (basic controls/rules)

private struct HowToPlaySheet: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.title2)
                Text("How to Play")
                    .font(.title2.bold())
            }

            VStack(alignment: .leading, spacing: 8) {
                Label("Tap the main bubble to score.", systemImage: "hand.tap.fill")
                Label("Avoid the red bomb — it removes a life.", systemImage: "xmark.octagon.fill")
                Label("Blue arrow: +5 points (quick!).", systemImage: "arrow.up.circle.fill")
                Label("Green clock: +3 seconds.", systemImage: "clock.fill")
                Label("Gold heart: +1 life.", systemImage: "heart.fill")
            }
            .font(.callout)
            .foregroundStyle(.secondary)

            Divider().padding(.vertical, 4)

            Text("Earn stars as you play — use them in Achievements to unlock new balls and backgrounds.")
                .font(.callout)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(20)
    }
}

// ---- Existing helpers from your current RootView (unchanged) ----

// Big menu button
private struct BigMenuButton: View {
    let title: String
    let systemImage: String
    var action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) { pressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                pressed = false; action()
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(width: 40, height: 40)
                    .background(Color.accentColor.opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .opacity(0.35)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: 360)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.22), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
            .scaleEffect(pressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// Animated background
private struct BubbleBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.blue.opacity(0.25),
                Color.teal.opacity(0.25)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)

            GeometryReader { _ in
                TimelineView(.animation) { timeline in
                    let dt = timeline.date.timeIntervalSinceReferenceDate
                    Canvas { ctx, size in
                        let w = size.width, h = size.height
                        for i in 0..<22 {
                            let seed = Double(i) * 123.45
                            let speed = 18.0 + fmod(seed, 22.0)
                            let radius = 18.0 + Double((i % 5) * 4)
                            let x = fmod(seed * 37.0, w)
                            let y = fmod((dt * speed + seed).truncatingRemainder(dividingBy: h + 120.0), h + 120.0) - 60.0
                            var bubble = Path(ellipseIn: CGRect(x: x, y: h - y, width: radius, height: radius))
                            ctx.fill(bubble, with: .color(.white.opacity(0.10)))
                            ctx.stroke(bubble, with: .color(.white.opacity(0.20)), lineWidth: 1)
                        }
                    }
                }
            }
            .allowsHitTesting(false)
            .opacity(0.9)
        }
        .ignoresSafeArea()
    }
}

// Rotating tip
private struct TipRotator: View {
    let tips: [String]
    @State private var idx = 0

    var body: some View {
        Text(tips[idx])
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 0.8)) {
                        idx = (idx + 1) % tips.count
                    }
                }
            }
    }
}


