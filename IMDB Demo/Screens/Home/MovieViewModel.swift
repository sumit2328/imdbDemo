//
//  MovieViewModel.swift
//  IMDB Demo
//
//  Created by Sumit on 01/07/24.
//

import Foundation

final class MovieViewModel {

    
    var model : MovieModel?
    

    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure

    var apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }
    
//    func getMovieByTitle(title:String) {
//        
//        self.eventHandler?(.loading)
//        APIManager.shared.request(
//            modelType: MovieModel.self, // response type
//            type: ProductEndPoint.getMovieList(title: title), isTokenRequired: true) { result,errorMsg  in
//                self.eventHandler?(.stopLoading)
//
//                switch result {
//                    
//                case .success(let product):
//                    self.model = product
//                    self.eventHandler?(.dataLoaded)
//
//                    self.eventHandler?(.newProductAdded(product: product))
//                    print("")
//                case .failure(let error):
//                    self.eventHandler?(.error(errorMsg))
//                }
//            }
//    }
    
    
    func getMovieByTitle(title: String) {
        self.eventHandler?(.loading)
        apiManager.request(
            modelType: MovieModel.self,
            type: ProductEndPoint.getMovieList(title: title),
            isTokenRequired: true
        ) { [weak self] result, errorMsg in
            self?.eventHandler?(.stopLoading)

            switch result {
            case .success(let product):
                self?.model = product
                self?.eventHandler?(.dataLoaded)
                self?.eventHandler?(.newProductAdded(product: product))
            case .failure(let error):
                self?.eventHandler?(.error(errorMsg))
            }
        }
    }

}

extension MovieViewModel {

    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
        case errorModel(errror: ErrorModel?)
        
        case newProductAdded(product: MovieModel)
    }

}

