import Foundation
import RxSwift

public protocol DatabaseProviderProtocol {
    func save(data: [GIFModelDTO])
    func fetchData() -> [GIFModelDTO]
}

public class DatabaseProvider: DatabaseProviderProtocol {
    private let disposeBag = DisposeBag()
    private let baseProvider = DependencyManager.resolve(BaseDatabaseProvider.self)
    private let coreDatabase = CoreProviderDatabase()

    private let decoder = JSONDecoder()

    public init() {}

    public func save(data: [GIFModelDTO]) {
        _ = baseProvider.save(data: data)        
    }

    public func fetchData() -> [GIFModelDTO] {
        return baseProvider.fetchData()
    }
}

extension CoreProviderDatabase: BaseDatabaseProvider {
    public func save(data: [GIFModelDTO]) -> Bool {
        do {
            let data = try JSONEncoder().encode(data)
            self.save(data: data)
            return true
        } catch {
            return false
        }
    }

    public func fetchData() -> [GIFModelDTO] {
        if let data: Data = self.fetch() {
            do {
                let model = try JSONDecoder().decode([GIFModelDTO].self, from: data)
                return model
            } catch {
                return []
            }
        }
        return []
    }
}
