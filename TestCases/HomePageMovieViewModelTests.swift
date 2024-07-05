import XCTest
@testable import IMDB_Demo

class MovieViewModelTests: XCTestCase {
    
    var viewModel: MovieViewModel!
    var mockAPIManager: MockAPIManager!

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = MovieViewModel(apiManager: mockAPIManager)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIManager = nil
        super.tearDown()
    }

    func testGetMovieByTitle_Success() {
        // Given
        let expectedMovie = MovieModel(Response: "True", Search: [Movie(Year: "2010", Title: "Inception", imdbID: "tt1375666", Poster: "poster_url")], totalResults: "1")
        mockAPIManager.result = .success(expectedMovie)
        
        let expectation = self.expectation(description: "Completion handler is called")
        
        viewModel.eventHandler = { event in
            switch event {
            case .loading:
                // Validate loading state
                break
            case .stopLoading:
                // Validate stop loading state
                break
            case .dataLoaded:
                XCTAssertEqual(self.viewModel.model, expectedMovie)
                expectation.fulfill()
            case .newProductAdded(let product):
                XCTAssertEqual(product, expectedMovie)
            case .error:
                XCTFail("Expected success but got error")
            default:
                break
            }
        }

        // When
        viewModel.getMovieByTitle(title: "Inception")
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetMovieByTitle_Failure() {
        // Given
        mockAPIManager.result = .failure(.invalidData)

        let expectation = self.expectation(description: "Completion handler is called")

        viewModel.eventHandler = { event in
            switch event {
            case .loading:
                // Validate loading state
                break
            case .stopLoading:
                // Validate stop loading state
                break
            case .error(let errorMsg):
                XCTAssertEqual(errorMsg, "Invalid data")
                expectation.fulfill()
            default:
                break
            }
        }

        // When
        viewModel.getMovieByTitle(title: "Inception")

        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }

}
