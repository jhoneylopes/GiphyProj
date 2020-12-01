import uCore

class DependencyInjector {
    static func load() {
        DependencyManager.register(GiphySearchProviderProtocol.self) {
            GiphySearchProvider()
        }

        DependencyManager.register(BaseProvider.self) {
            CoreAPIService()
        }

        DependencyManager.register(DatabaseProviderProtocol.self) {
            DatabaseProvider()
        }

        DependencyManager.register(BaseDatabaseProvider.self) {
            CoreProviderDatabase()
        }
    }
}
