//
//  NetworkImageService.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import Foundation


protocol NetworkImageService {
    func fetchImages(_ success: @escaping ([Image]) -> Void, failure: @escaping (Error) -> Void)
}

class NetworkManager: NetworkImageService {
    func fetchImages(_ success: @escaping ([Image]) -> Void, failure: @escaping (Error) -> Void) {
        
        guard Reachability.isConnectedToNetwork() else {
            failure(LocalError.badInternet)
            return
        }
        
        guard let url = URL(string: "https://www.reddit.com/r/pics/.json?jsonp=") else {
            failure(LocalError.badURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure(LocalError.generic(error))
                return
            }
            do {
                let imageData = try JSONDecoder().decode(ImageResponse.self, from: data!)
                success(imageData.images)
            } catch {
                failure(LocalError.parsingFailed(error))
            }
        }
        task.resume()
    }
}

enum LocalError: Error, CustomStringConvertible {
    case badInternet
    case badURL
    case parsingFailed(Error)
    case generic(Error)
    
    var description: String {
        switch self {
        case .badInternet:
            return "Please check your network"
        case .badURL:
            return "Seems like a bad request, please contact your app developer."
        case .parsingFailed(let error):
            return "Something went wrong. \(error.localizedDescription)"
        case .generic(let error):
            return "Something went wrong. \(error.localizedDescription)"
        }
    }
}
