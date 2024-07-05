//
//  coreDataUnitTests.swift
//  IMDB DemoTests
//
//  Created by Sumit on 05/07/24.
//

import XCTest
import CoreData
@testable import IMDB_Demo

class MovieManagerTests: XCTestCase {

    var movieManager: MovieManager!
    var persistentContainer: NSPersistentContainer!

    override func setUpWithError() throws {
        // Initialize MovieManager with an in-memory persistent store
        movieManager = MovieManager.shared
        persistentContainer = {
            let container = NSPersistentContainer(name: "demoCore")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                if let error = error {
                    fatalError("Failed to load in-memory store: \(error)")
                }
            }
            return container
        }()
        
        // Replace the persistentContainer in MovieManager
        movieManager.persistentContainer = persistentContainer
    }

    override func tearDownWithError() throws {
        movieManager = nil
        persistentContainer = nil
    }

    func testSaveMovie() throws {
        // Given
        let imageUrl = "https://example.com/poster.jpg"
        let title = "Inception"
        let year = "2010"
        let imdbId = "tt1375666"
        
        // When
        movieManager.saveMovie(imageUrl: imageUrl, title: title, year: year, imdbId: imdbId)
        
        // Then
        let movies = movieManager.fetchMovies()
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies.first?.imageUrl, imageUrl)
        XCTAssertEqual(movies.first?.title, title)
        XCTAssertEqual(movies.first?.year, year)
        XCTAssertEqual(movies.first?.imdbId, imdbId)
    }

    func testRemoveMovie() throws {
        // Given
        let context = persistentContainer.viewContext
        let movie = Movies(context: context)
        movie.imageUrl = "https://example.com/poster.jpg"
        movie.title = "Inception"
        movie.year = "2010"
        movie.imdbId = "tt1375666"
        try context.save()

        // When
        movieManager.removeMovie(movie: movie)

        // Then
        let movies = movieManager.fetchMovies()
        XCTAssertEqual(movies.count, 0)
    }

    func testFetchMovies() throws {
        // Given
        let context = persistentContainer.viewContext
        let movie1 = Movies(context: context)
        movie1.imageUrl = "https://example.com/poster1.jpg"
        movie1.title = "Inception"
        movie1.year = "2010"
        movie1.imdbId = "tt1375666"

        let movie2 = Movies(context: context)
        movie2.imageUrl = "https://example.com/poster2.jpg"
        movie2.title = "The Dark Knight"
        movie2.year = "2008"
        movie2.imdbId = "tt0468569"
        
        try context.save()

        // When
        let movies = movieManager.fetchMovies()

        // Then
        XCTAssertEqual(movies.count, 2)
        XCTAssertNotNil(movies[0].title)
        

    }
}
