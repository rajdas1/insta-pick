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
        
        guard let url = URL(string: "https://www.reddit.com/r/pics/.json?jsonp=") else {
            failure(LocalError.badURL)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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

enum LocalError: Error {
    case badURL
    case parsingFailed(Error)
}
