


import Foundation

enum ShopPricing {
    /// Pricing for a 25-item catalog: 0-9 => 100, 10-19 => 250, 20-24 => 500
    static func price(forIndex i: Int) -> Int {
        switch i {
        case 0..<10:  return 100
        case 10..<20: return 250
        case 20..<25: return 500
        default:      return 500
        }
    }
}
