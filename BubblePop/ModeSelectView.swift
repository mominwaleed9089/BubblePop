import SwiftUI

struct ModeSelectView: View {
    var body: some View {
        ZStack {
            // 🔹 Animated background
            LinearGradient(colors: [
                Color.blue.opacity(0.25),
                Color.teal.opacity(0.25)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            GeometryReader { _ in
                TimelineView(.animation) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    Canvas { ctx, size in
                        let w = size.width, h = size.height
                        for i in 0..<20 {
                            let seed = Double(i) * 123.45
                            let speed = 18.0 + fmod(seed, 22.0)
                            let radius = 18.0 + Double((i % 5) * 4)
                            let x = fmod(seed * 37.0, w)
                            let y = fmod((t * speed + seed).truncatingRemainder(dividingBy: h + 120.0), h + 120.0) - 60.0

                            let bubbleRect = CGRect(x: x, y: h - y, width: radius, height: radius)
                            var bubble = Path(ellipseIn: bubbleRect)
                            ctx.fill(bubble, with: .color(.white.opacity(0.10)))
                            ctx.stroke(bubble, with: .color(.white.opacity(0.20)), lineWidth: 1)
                        }
                    }
                }
            }
            .allowsHitTesting(false)
            .opacity(0.9)

            // 🔹 Foreground UI (slightly upward)
            VStack(spacing: 20) {
                Spacer(minLength: 40)   // top space

                Text("Choose Game Mode")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .shadow(radius: 1)
                    .padding(.bottom, 12)

                ModeCard(
                    title: "Normal",
                    subtitle: "60s • 3 lives • steady play",
                    icon: "circle.fill",
                    tint: .blue
                ) {
                    GameView(mode: .normal)
                }

                ModeCard(
                    title: "Risk+",
                    subtitle: "Powerups & hazards • quicker spawns",
                    icon: "flame.fill",
                    tint: .orange
                ) {
                    GameView(mode: .risk)
                }

                /*
                ModeCard(
                    title: "Time Trial",
                    subtitle: "100 levels • rising difficulty",
                    icon: "timer",
                    tint: .purple
                ) {
                    TimeTrialView()
                }
                */

                Spacer(minLength: 120)  // bigger bottom space → pushes stack up
            }
            .padding(.horizontal, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ModeCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let tint: Color
    @ViewBuilder var destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(tint, in: RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title3.bold())
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(.white.opacity(0.15)))
            .shadow(color: Color.black.opacity(0.08), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}
