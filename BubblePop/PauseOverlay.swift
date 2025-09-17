import SwiftUI

struct PauseOverlay: View {
    var resume: () -> Void
    var restart: () -> Void
    var quit: () -> Void

    @State private var appear = false

    var body: some View {
        ZStack {
            // Dim blur behind the card
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            // Floating card
            VStack(spacing: 16) {
                Text("Paused")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))

                VStack(spacing: 12) {
                    SimpleMenuButton(title: "Resume") {
                        impact(.light)
                        resume()
                    }
                    SimpleMenuButton(title: "Restart") {
                        impact(.medium)
                        restart()
                    }
                    SimpleMenuButton(title: "Main Menu") {
                        impact(.soft)
                        quit()
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 340)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 18, x: 0, y: 10)
            .scaleEffect(appear ? 1 : 0.95)
            .opacity(appear ? 1 : 0)
            .animation(.spring(response: 0.32, dampingFraction: 0.85), value: appear)
            .onAppear { appear = true }
            .padding(.horizontal, 24)
        }
        .interactiveDismissDisabled(true) // only close via buttons
    }

    private func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        #if os(iOS)
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.prepare(); gen.impactOccurred()
        #endif
    }
}

private struct SimpleMenuButton: View {
    let title: String
    var action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) { pressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                pressed = false
                action()
            }
        } label: {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: Color.accentColor.opacity(0.35), radius: 8, x: 0, y: 6)
                .scaleEffect(pressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
    }
}
