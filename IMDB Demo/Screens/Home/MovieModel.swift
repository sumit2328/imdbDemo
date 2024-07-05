//
//  MovieModel.swift
//  IMDB Demo
//
//  Created by Sumit on 01/07/24.
//

import Foundation



//struct MovieModel: Codable {

struct MovieModel: Codable, Equatable {
    var Response: String?
    var Search: [Movie]?
    var totalResults: String?

    static func == (lhs: MovieModel, rhs: MovieModel) -> Bool {
        return lhs.Response == rhs.Response &&
               lhs.Search == rhs.Search &&
               lhs.totalResults == rhs.totalResults
    }
}

struct Movie: Codable, Equatable {
    var Year: String?
    var Title: String?
    var imdbID: String?
    var Poster: String?

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.Year == rhs.Year &&
               lhs.Title == rhs.Title &&
               lhs.imdbID == rhs.imdbID &&
               lhs.Poster == rhs.Poster
    }
}

    
    
struct ErrorModel: Codable {
    let Response: Bool?
    let Error: String?
}


