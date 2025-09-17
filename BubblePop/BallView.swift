import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct BallView: View {
    @EnvironmentObject private var progress: PlayerProgress   // << read selectedBallID
    let ball: Ball

    // Sizes
    private let normalSize: CGFloat = 84
    private var iconSize: CGFloat {
        switch ball.type {
        case .gold:  return 73
        case .blue:  return 65
        case .green: return 65
        case .red:   return 65
        case .normal: return 0
        }
    }

    // Icons for specials
    private var symbolName: String? {
        switch ball.type {
        case .normal: return nil
        case .blue:   return "arrow.up"
        case .green:  return "clock.fill"
        case .gold:   return "heart.fill"
        case .red:
            #if canImport(UIKit)
            if UIImage(systemName: "bomb.fill") != nil { return "bomb.fill" }
            #endif
            return "exclamationmark.octagon.fill"
        }
    }
    private var symbolTint: Color {
        switch ball.type {
        case .gold:  return .yellow
        case .blue:  return .blue
        case .green: return .green
        case .red:   return .red
        case .normal: return .clear
        }
    }

    var body: some View {
        ZStack {
            switch ball.type {
            case .normal(let base):
                let style = Palette.ballStyle(for: progress.selectedBallID)

                switch style {
                case .solid:
                    Circle()
                        .fill(base)
                        .frame(width: normalSize, height: normalSize)
                        .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)
                        .overlay(Circle().stroke(.white.opacity(0.25), lineWidth: 1))

                case .neon:
                    Circle()
                        .fill(base)
                        .frame(width: normalSize, height: normalSize)
                        // neon “outer” glow
                        .shadow(color: base.opacity(0.75), radius: 14, x: 0, y: 0)
                        .shadow(color: base.opacity(0.45), radius: 22, x: 0, y: 0)
                        // inner glossy highlight
                        .overlay(
                            Circle().fill(
                                RadialGradient(
                                    colors: [Color.white.opacity(0.45), Color.clear],
                                    center: .topLeading, startRadius: 0, endRadius: 60
                                )
                            )
                        )
                        .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))

                case .glossy:
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [base.lighten(0.25), base],
                                center: .topLeading, startRadius: 6, endRadius: 70
                            )
                        )
                        .frame(width: normalSize, height: normalSize)
                        .shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 5)
                        .overlay(
                            Circle().stroke(.white.opacity(0.18), lineWidth: 1)
                        )
                }

            default:
                if let name = symbolName {
                    Image(systemName: name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundStyle(symbolTint)
                        .shadow(radius: 3)
                        .accessibilityHidden(true)
                }
            }
        }
        .padding(18)                 // tap forgiveness
        .contentShape(Rectangle())
        .transition(.scale)
    }
}
