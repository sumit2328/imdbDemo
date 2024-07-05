//
//  MovieManager.swift
//  IMDB Demo
//
//  Created by Sumit on 02/07/24.
//

import UIKit
import CoreData

class MovieManager {

    static let shared = MovieManager()

    private init() {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "demoCore")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveMovie(imageUrl: String, title: String, year: String, imdbId : String) {
        let context = persistentContainer.viewContext
        let movie = Movies(context: context)

        movie.imageUrl = imageUrl
        movie.title = title
        movie.year = year
        movie.imdbId = imdbId
        movie.isFavorite = false // Default value

        do {
            try context.save()
            print("Movie saved successfully")
        } catch {
            print("Failed to save movie: \(error)")
        }
    }

    // MARK: - Core Data Removing support

    func removeMovie(movie: Movies) {
        let context = persistentContainer.viewContext
        context.delete(movie)

        do {
            try context.save()
            print("Movie deleted successfully")
        } catch {
            print("Failed to delete movie: \(error)")
        }
    }

    // MARK: - Fetching Movies

    func fetchMovies() -> [Movies] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Movies> = Movies.fetchRequest()

        do {
            let movies = try context.fetch(fetchRequest)
            return movies
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }
}
