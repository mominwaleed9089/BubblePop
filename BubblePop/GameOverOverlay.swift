import SwiftUI

struct GameOverOverlay: View {
    let score: Int
    let livesLeft: Int
    let bonusPerLife: Int
    let isNewHighScore: Bool   // ⭐ NEW

    var onReplay: () -> Void
    var onMenu: () -> Void

    private var lifeBonus: Int { max(0, min(livesLeft, 3) * bonusPerLife) }

    var body: some View {
        VStack(spacing: 16) {
            // Grab handle
            Capsule()
                .fill(Color.secondary.opacity(0.25))
                .frame(width: 36, height: 4)
                .padding(.top, 6)

            // Title + (optional) New High Score badge
            VStack(spacing: 8) {
                Text("Game Over")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))

                if isNewHighScore {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                        Text("New High Score!")
                            .font(.footnote.weight(.semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.15), in: Capsule())
                    .overlay(Capsule().stroke(Color.accentColor.opacity(0.25), lineWidth: 1))
                }
            }
            .padding(.top, 4)

            // Score
            VStack(spacing: 4) {
                Text("Score")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("\(score)")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .shadow(radius: 1)
                    .accessibilityLabel("Score \(score)")
            }

            // Lives + bonus (only if any lives left)
            if livesLeft > 0 {
                HStack(spacing: 10) {
                    HeartRow(count: livesLeft)
                    Spacer(minLength: 0)
                    HStack(spacing: 6) {
                        Image(systemName: "star.circle.fill")
                        Text("+\(lifeBonus)")
                            .font(.subheadline.bold())
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.6), in: Capsule())
                    .foregroundStyle(.white)
                }
                .padding(.top, 4)
            }

            Divider().padding(.vertical, 2)

            // Actions
            VStack(spacing: 10) {
                Button(action: onReplay) {
                    HStack { Image(systemName: "arrow.clockwise.circle.fill"); Text("Replay").font(.headline) }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)

                Button(action: onMenu) {
                    HStack { Image(systemName: "house.fill"); Text("Main Menu").font(.headline) }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(.white.opacity(0.2), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }

            Text("You’ll keep any stars earned this round.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 4)

            Spacer(minLength: 4)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 12)
    }
}

// MARK: - Hearts row
private struct HeartRow: View {
    let count: Int
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < count ? "heart.fill" : "heart")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(i < count ? Color.red : Color.secondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(count) lives left")
    }
}
