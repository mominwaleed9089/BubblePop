import SwiftUI

struct CurrencyPill: View {
    let amount: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.circle.fill")
            Text("\(amount)")
                .font(.headline)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.thinMaterial, in: Capsule())
        .accessibilityLabel("Currency \(amount)")
    }
}
