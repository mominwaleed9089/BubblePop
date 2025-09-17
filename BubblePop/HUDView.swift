import SwiftUI

struct HUDView: View {
    let score: Int
    let lives: Int
    let time: Int
    var onPause: () -> Void

    var body: some View {
        HStack {
            // Hearts on the left
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < lives ? "heart.fill" : "heart")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            i < lives ? Color.red : Color.gray.opacity(0.7),
                            Color.white
                        )
                        .font(.title2)
                        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
                }
            }

            Spacer()

            // Pause button on the right
            Button(action: onPause) {
                Image(systemName: "pause.circle.fill")
                    .font(.title2)
            }
        }
        .overlay(
            // Timer sits centered over the whole row
            Text("\(time)s")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .shadow(radius: 1)
                .offset(x: +12),   // ⬅ tweak this value to move left/right
            alignment: .center
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
