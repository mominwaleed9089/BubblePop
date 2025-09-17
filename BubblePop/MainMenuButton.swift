import SwiftUI

struct MainMenuButton: View {
    let title: String
    var action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { pressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                pressed = false
                action()
            }
        }) {
            Text(title)
                .font(.title2.bold())
                .padding(.vertical, 16)
                .frame(maxWidth: 360)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(.white.opacity(0.25)))
                .scaleEffect(pressed ? 0.96 : 1.0)
        }
        .buttonStyle(.plain)
    }
}
