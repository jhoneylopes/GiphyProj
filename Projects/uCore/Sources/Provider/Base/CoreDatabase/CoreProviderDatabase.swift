import Foundation
import RxSwift

public class CoreProviderDatabase {
    private let defaults = UserDefaults.standard
    private let baseKey: String

    public init(baseKey: String = "FavoritesGIFs") {
        self.baseKey = baseKey
    }

    func save(data: Data) {
        defaults.set(data, forKey: baseKey)
    }

    func fetch() -> Data? {
        defaults.object(forKey: baseKey) as? Data
    }
}
