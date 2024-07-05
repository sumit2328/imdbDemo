//
//  ProductEndPoint.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 15/01/23.
//

import Foundation
//http://67.205.177.49/tipstars/public/api/forgot-password
enum ProductEndPoint {

    case getMovieList(title : String)
    case getMovieDetails(byId : String)

}

extension ProductEndPoint: EndPointType {

    var path: String {
        switch self {

        case .getMovieList:
            
            return ""
          
        case .getMovieDetails:
            
            return ""

        }
    }
    
    var baseURL: String {

        switch self {

        case .getMovieList(title: let txt):
            return "https://www.omdbapi.com/?s=\(txt)&apikey=bd447c79"//"https://www.omdbapi.com/?t=\(txt)&apikey=bd447c79"

        case .getMovieDetails(byId: let id):
            
            return "https://www.omdbapi.com/?i=\(id)&apikey=bd447c79"

            
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {

        case .getMovieList:
            return  .get
            
        case .getMovieDetails:
            
            return .get

        }
    }

    var body: Encodable? {
        switch self {

        case .getMovieList:
            return  nil
            

        case .getMovieDetails:
                return nil
        }
    }

    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
