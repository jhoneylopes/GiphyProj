import RxSwift
@testable import uCore

final class MockDatabaseProvider: DatabaseProviderProtocol {
    var didCallSaveMock: Bool = false

    func save(data: [GIFModelDTO]) {
        didCallSaveMock = true
    }

    func fetchData() -> [GIFModelDTO] {
        return [GIFModelDTO(id: "id99", images: nil)]
    }
}
