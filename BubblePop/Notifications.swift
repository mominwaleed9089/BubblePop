import Foundation

extension Notification.Name {
    /// Posted when gameplay grants soft currency; `object` should be `Int` amount.
    static let awardCurrency = Notification.Name("AWARD_CURRENCY")
}
