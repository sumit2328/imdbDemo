//
//  MockAPIManager.swift
//  IMDB Demo
//
//  Created by Sumit on 04/07/24.
//

//import Foundation

protocol APIManagerProtocol {
    func request<T: Codable>(modelType: T.Type, type: EndPointType, isTokenRequired: Bool, completion: @escaping ResultHandler<T>)
}


class MockAPIManager: APIManagerProtocol {
    var result: Result<Any, DataError>?
    
    func request<T: Codable>(modelType: T.Type, type: EndPointType, isTokenRequired: Bool, completion: @escaping ResultHandler<T>) {
        guard let result = result else {
            completion(.failure(.invalidData), "No result set in mock")
            return
        }
        
        switch result {
        case .success(let data):
            if let data = data as? T {
                completion(.success(data), "")
            } else {
                completion(.failure(.invalidData), "Invalid data type")
            }
        case .failure(let error):
            completion(.failure(error), "Invalid data")
        }
    }
}
