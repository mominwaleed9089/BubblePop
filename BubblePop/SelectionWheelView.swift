import SwiftUI

struct SelectionWheel: View {
    let items: [ShopItem]
    @Binding var selectedID: Int
    var isUnlocked: (Int) -> Bool
    var priceFor: (Int) -> Int
    var onPurchase: (Int, Int) -> Void

    private let swatchSize: CGFloat = 80
    private let cellWidth: CGFloat = 104
    private let cellHeight: CGFloat = 128

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(items) { item in
                    ZStack(alignment: .bottom) {
                        // Ball / background swatch
                        item.display
                            .frame(width: swatchSize, height: swatchSize)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .strokeBorder(.white.opacity(0.25))
                            )
                            .opacity(isUnlocked(item.id) ? 1 : 0.55)
                            .contentShape(RoundedRectangle(cornerRadius: 18))
                            .onTapGesture {
                                if isUnlocked(item.id) { selectedID = item.id }
                            }

                        // Selected checkmark
                        if selectedID == item.id && isUnlocked(item.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .shadow(radius: 2)
                                .padding(.bottom, 8)
                                .transition(.scale)
                        }

                        // LOCKED overlay with price + Buy button
                        if !isUnlocked(item.id) {
                            let price = priceFor(item.id)
                            VStack(spacing: 6) {
                                Text("\(price)★")
                                    .font(.caption).bold()

                                Button("Buy") {
                                    onPurchase(item.id, price)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.black.opacity(0.7)) // ⬅ darker tone
                                .controlSize(.small)
                                .font(.caption)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            
                        }
                    }
                    .frame(width: cellWidth, height: cellHeight)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
    }
}
