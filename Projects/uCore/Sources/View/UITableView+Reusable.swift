import UIKit

public extension UITableView {
    func register<C: UITableViewCell & Reusable>(_ type: C.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueReusableCell<C: UITableViewCell & Reusable>(for indexPath: IndexPath) -> C {
        guard let cell = dequeueReusableCell(withIdentifier: C.reuseIdentifier, for: indexPath) as? C else {
            fatalError(
                "Could not dequeue reusable cell identified by \(C.reuseIdentifier): "
                    + "cell not registered or of wrong type"
            )
        }

        return cell
    }
}
