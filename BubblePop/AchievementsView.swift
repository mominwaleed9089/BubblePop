import SwiftUI

struct AchievementsShopView: View {
    @EnvironmentObject var progress: PlayerProgress

    private let ballCount = 25
    private let bgCount   = 25

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Achievements & Customise")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                    Spacer()
                }
                .padding(.horizontal)

                // BALLS (solid/neon/glossy colors)
                ShopSectionBalls(
                    count: ballCount,
                    colorAt: { Palette.ballColors[safe: $0] ?? .gray },
                    isUnlocked: { progress.isUnlocked(category: .ball, id: $0) },
                    isSelected: { progress.selectedBallID == $0 },
                    priceFor: { ShopPricing.price(forIndex: $0) },
                    onSelect: { id in progress.selectedBallID = id },
                    onUnlock: { id, price in
                        guard progress.spendCurrency(price) else { return }
                        progress.unlock(category: .ball, id: id)
                        progress.selectedBallID = id
                    }
                )

                // BACKGROUNDS (solid or gradient)
                ShopSectionBackgrounds(
                    count: bgCount,
                    isUnlocked: { progress.isUnlocked(category: .background, id: $0) },
                    isSelected: { progress.selectedBackgroundID == $0 },
                    priceFor: { ShopPricing.price(forIndex: $0) },
                    onSelect: { id in progress.selectedBackgroundID = id },
                    onUnlock: { id, price in
                        guard progress.spendCurrency(price) else { return }
                        progress.unlock(category: .background, id: id)
                        progress.selectedBackgroundID = id
                    }
                )
            }
            .padding(.vertical, 18)
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Balls Section (uses Color)

private struct ShopSectionBalls: View {
    let count: Int
    let colorAt: (Int) -> Color
    let isUnlocked: (Int) -> Bool
    let isSelected: (Int) -> Bool
    let priceFor: (Int) -> Int
    let onSelect: (Int) -> Void
    let onUnlock: (Int, Int) -> Void

    private let cols = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Balls")
                .font(.title2.bold())
                .padding(.horizontal)

            LazyVGrid(columns: cols, spacing: 14) {
                ForEach(0..<count, id: \.self) { i in
                    BallCell(
                        color: colorAt(i),
                        unlocked: isUnlocked(i),
                        selected: isSelected(i),
                        price: priceFor(i),
                        onSelect: { onSelect(i) },
                        onUnlock: { onUnlock(i, priceFor(i)) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct BallCell: View {
    let color: Color
    let unlocked: Bool
    let selected: Bool
    let price: Int
    let onSelect: () -> Void
    let onUnlock: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 82, height: 82)
                .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
                .overlay(
                    Circle().stroke(Color.accentColor.opacity(selected ? 0.9 : 0), lineWidth: 3)
                )
                .onTapGesture { unlocked ? onSelect() : onUnlock() }

            if !unlocked {
                PricePill(price: price)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Backgrounds Section (uses gradient-capable swatch)

private struct ShopSectionBackgrounds: View {
    let count: Int
    let isUnlocked: (Int) -> Bool
    let isSelected: (Int) -> Bool
    let priceFor: (Int) -> Int
    let onSelect: (Int) -> Void
    let onUnlock: (Int, Int) -> Void

    private let cols = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Backgrounds")
                .font(.title2.bold())
                .padding(.horizontal)

            LazyVGrid(columns: cols, spacing: 14) {
                ForEach(0..<count, id: \.self) { i in
                    BackgroundCell(
                        index: i,
                        unlocked: isUnlocked(i),
                        selected: isSelected(i),
                        price: priceFor(i),
                        onSelect: { onSelect(i) },
                        onUnlock: { onUnlock(i, priceFor(i)) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct BackgroundCell: View {
    let index: Int
    let unlocked: Bool
    let selected: Bool
    let price: Int
    let onSelect: () -> Void
    let onUnlock: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            // Gradient-aware preview from Palette
            Palette.backgroundSwatch(for: index, cornerRadius: 14)
                .frame(height: 82)
                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)

                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.accentColor.opacity(selected ? 0.9 : 0), lineWidth: 3)
                )
                .onTapGesture { unlocked ? onSelect() : onUnlock() }

            if !unlocked {
                PricePill(price: price)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Price pill

private struct PricePill: View {
    let price: Int
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.circle.fill")
            Text("\(price)")
                .font(.subheadline.bold())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.6), in: Capsule())
        .foregroundStyle(.white)
    }
}
