//
//  DetailsPageViewModel.swift
//  IMDB Demo
//
//  Created by Sumit on 01/07/24.
//


import Foundation

final class DetailsPageViewModel {
    
    var model: MovieDetailsModel?
    var eventHandler: ((_ event: Event) -> Void)?
    
    func getMovieDetailsById(id: String) {
        // Notify loading start
        self.eventHandler?(.loading)
        
        // Make API request
        APIManager.shared.request(
            modelType: MovieDetailsModel.self,
            type: ProductEndPoint.getMovieDetails(byId: id),
            isTokenRequired: true) { [weak self] result, errorMsg in
                guard let self = self else { return }
                
                // Notify loading stop regardless of success or failure
                self.eventHandler?(.stopLoading)
                
                switch result {
                case .success(let product):
                    // Update model
                    self.model = product
                    
                    // Notify data loaded
                    self.eventHandler?(.dataLoaded)
                    
                    // Notify new product added (optional, depending on your app logic)
                    self.eventHandler?(.newProductAdded(product: product))
                    
                case .failure(let error):
                    // Notify error
                    self.eventHandler?(.error(errorMsg))
                }
            }
    }
}

extension DetailsPageViewModel {
    
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(String?)
        case newProductAdded(product: MovieDetailsModel)
    }
}
