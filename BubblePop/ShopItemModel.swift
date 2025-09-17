import SwiftUI

enum ShopCategory: Hashable { // ✅ now Hashable
    case ball, background
}

struct ShopItem: Identifiable, Hashable {
    let id: Int
    let category: ShopCategory
    let display: AnyView // Circle/Rectangle swatch
    let isGradient: Bool

    // ✅ Custom equality & hash only use id + category
    static func == (lhs: ShopItem, rhs: ShopItem) -> Bool {
        lhs.id == rhs.id && lhs.category == rhs.category
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(category)
    }
}
