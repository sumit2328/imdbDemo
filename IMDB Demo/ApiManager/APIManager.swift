//
//  APIManager.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 23/12/22.
//

import Foundation
import UIKit

// Singleton Design Pattern
// final - inheritance nahi hoga theek hai final ho gya

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}

typealias ResultHandler<T> = (Result<T, DataError>,String) -> Void

final class APIManager: APIManagerProtocol {
    static let shared = APIManager()
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler
   // private var customLoader: CustomLoader

    private init(networkHandler: NetworkHandler = NetworkHandler(), responseHandler: ResponseHandler = ResponseHandler()) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
        //self.customLoader = CustomLoader()
    }


    func request<T: Codable>(modelType: T.Type, type: EndPointType, isTokenRequired: Bool, completion: @escaping ResultHandler<T>) {
       // let customLoader = CustomLoader()
        //customLoader = CustomLoader(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        DispatchQueue.main.async {
           // self.customLoader.startAnimation()
        }

        guard let url = type.url else {
            completion(.failure(.invalidURL), "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue

        if let parameters = type.body {
            do {
                request.httpBody = try JSONEncoder().encode(parameters)
            } catch {
                completion(.failure(.invalidData), "JSON Encoding Error: \(error.localizedDescription)")
                return
            }
        }

        if isTokenRequired {
            let authToken = UserDefaults.standard.value(forKey: "access_token") as? String ?? ""
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        request.allHTTPHeaderFields = type.headers

        networkHandler.requestDataAPI(url: request) { result in
            DispatchQueue.main.async {
               /// self.customLoader.stopAnimation()
            }

            switch result {
            case .success(let data):
                self.responseHandler.parseResonseDecode(data: data, modelType: modelType) { response, errorString in
                    switch response {
                    case .success(let mainResponse):
                        completion(.success(mainResponse), errorString)
                    case .failure(let error):
                        completion(.failure(error), error.localizedDescription)
                    }
                }
            case .failure(let error):
                completion(.failure(.network(error)), error.localizedDescription ?? "Network Error")
            }
        }
    }

    static var commonHeaders: [String: String] {
        return ["Content-Type": "application/json"]
    }
}



// Like banta hai guys

class NetworkHandler {

    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, DataError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            if let mainData = data{

                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: mainData, options: []) as? [String: Any] {
                        // try to read out a string array
                        
                        
                        if let jsonString = String(data: try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted), encoding: .utf8) {
                            print(jsonString)
                        } else {
                            print("Failed to convert JSON object to string")
                        }
                        
                        
                        if let message = json["message"] as? String {
                            
//                            if message == "Session expired!"{
//                                DispatchQueue.main.async {
//                                    
//                                    
//                                    UserDefaults.standard.setValue(0, forKey: "isLogin")
//
//                                    
//                                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                    var vc = mainStoryboard.instantiateViewController(withIdentifier: "welcomeVc")// as! tabBar
//                                    vc.showToast(message)
//                                    UIApplication.shared.keyWindow?.rootViewController = vc
//                                    return
//                                    
//                                }
//                            }
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }


            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                
                
                
                if let responseData =  data  {
                    
                    completionHandler(.success(responseData))

                   // completionHandler(.failure(.invalidData))
                    
                }else{
                     completionHandler(.failure(.invalidData))

                }
                return
                //completionHandler(.success(data))
               // completionHandler(.success(data))

                completionHandler(.failure(.invalidResponse))
                return
            }

            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }

            // Attempt to serialize the received data as JSON

        

            
            completionHandler(.success(data))
        }
        session.resume()
    }

}

class ResponseHandler {

    func parseResonseDecode<T: Decodable>(data: Data,modelType: T.Type,completionHandler: ResultHandler<T>) {
        
        
        var msg = ""
        
        do {
            let errorResponse = try JSONDecoder().decode(ErrorModel.self, from: data)
            
            msg = errorResponse.Error ?? "Something wrong"
            
            //completionHandler(.success(userResponse), "")
        }catch {
            completionHandler(.failure(.decoding(error)), msg)

            print("error")
            
           // completionHandler(.failure(.decoding(error)), "")
        }
        
        
        
        
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            completionHandler(.success(userResponse), "")
            
            print(userResponse)
        }catch {
            
            print(error.localizedDescription)
            
             completionHandler(.failure(.decoding(error)), msg)

        }
        
    }

}
