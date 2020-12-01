@testable import uCore

class UnitTestDependencyInjector {
    static func reset() {
        DependencyManager.clean()
    }

    static func load() {
        let search = MockGiphySearchProvider()
        let database = MockDatabaseProvider()

        DependencyManager.register(GiphySearchProviderProtocol.self) {
            search
        }

        DependencyManager.register(DatabaseProviderProtocol.self) {
            database
        }
    }
}
