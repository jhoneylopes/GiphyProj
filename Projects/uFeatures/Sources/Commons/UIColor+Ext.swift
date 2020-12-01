import UIKit

extension UIColor {
    static func funColor(by index: Int) -> UIColor {
        switch index % 4 {
        case 1: return UIColor.green.withAlphaComponent(0.65)
        case 2: return UIColor.orange.withAlphaComponent(0.65)
        case 3: return UIColor.purple.withAlphaComponent(0.65)
        default: return UIColor.blue.withAlphaComponent(0.65)
        }
    }
}
