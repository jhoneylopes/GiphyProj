import RxSwift
import RxTest
@testable import uCore
@testable import uFeatures
import XCTest

class HomeViewControllerTests: XCTestCase {
    var sut: HomeViewController!
    let fakeState: AppStateProtocol = UnitAppState.shared

    lazy var mockGiphyProvider: MockGiphySearchProvider = {
        guard let provider = DependencyManager.resolve(GiphySearchProviderProtocol.self) as? MockGiphySearchProvider else {
            fatalError("Missing dependency")
        }
        return provider
    }()

    lazy var mockDatabaseProvider: MockDatabaseProvider = {
        guard let provider = DependencyManager.resolve(DatabaseProviderProtocol.self) as? MockDatabaseProvider else {
            fatalError("Missing dependency")
        }
        return provider
    }()

    override func setUp() {
        super.setUp()
        UnitTestDependencyInjector.load()
        self.sut = HomeViewController(serviceProvider: mockGiphyProvider, state: fakeState)
    }

    func test_Fetch_CallsProvider() {
        sut.fetch("", 0)

        XCTAssertTrue(mockGiphyProvider.didCallMock)
    }

    func test_IsFavorited_WhenAGifWasAddedToFavoriteList_ReturnsTrue() {
        XCTAssertTrue(sut.isFavorited(by: "id1"))
    }

    func test_InfiniteScroll_WhenIsInTheEndOfTheCurrentList_CallsProvider() {
        sut.infiniteScroll(current: 9)

        XCTAssertTrue(mockGiphyProvider.didCallMock)
    }

    func test_FavoritManager_WhenGifIsNotInTheFavoriteList_AddsGif() {
        let expected = GIFModelDTO(id: "id123", images: nil)
        let newList = sut.favoriteManager(gif: expected)

        XCTAssertTrue(newList.contains(expected))
    }

    func test_FavoritManager_WhenGifIsInTheFavoriteList_RemovesGif() {
        let expected = GIFModelDTO(id: "id1", images: nil)
        let newList = sut.favoriteManager(gif: expected)

        XCTAssertFalse(newList.contains(expected))
    }

    func test_UpdateFavoriteList_AddsGifInFavoriteList() {
        sut.updateFavoriteList(with: [GIFModelDTO(id: "id456", images: nil)])

        XCTAssertTrue(sut.isFavorited(by: "id456"))
    }

    func test_Save_CallsDatabaseProvider() {
        sut.save([GIFModelDTO(id: "id1", images: nil)])

        XCTAssertTrue(mockDatabaseProvider.didCallSaveMock)
    }
}
