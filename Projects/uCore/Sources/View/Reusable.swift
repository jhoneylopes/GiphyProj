import UIKit

/// Define reusable protocol
public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

/// Makes cells reusables
protocol ReusableCell: Reusable {
    associatedtype Item

    static var itemSize: CGSize { get }

    func render(_ item: Item)
}

extension ReusableCell {
    func render(_: Item) {}
}

extension ReusableCell where Self: UICollectionViewCell {
    static var itemSize: CGSize {
        return .zero
    }
}

extension ReusableCell where Self: UITableViewCell {
    static var itemSize: CGSize {
        return .zero
    }
}
