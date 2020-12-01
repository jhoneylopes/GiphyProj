import UIKit

public extension UICollectionView {
    func register<C: UICollectionViewCell & Reusable>(_ type: C.Type) {
        register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueReusableCell<C: UICollectionViewCell & Reusable>(for indexPath: IndexPath) -> C {
        guard let cell = dequeueReusableCell(withReuseIdentifier: C.reuseIdentifier, for: indexPath) as? C else {
            fatalError(
                "Could not dequeue reusable cell identified by \(C.reuseIdentifier): "
                    + "cell not registered or of wrong type"
            )
        }

        return cell
    }
}
