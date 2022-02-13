//
//  NetworkImageService.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import Foundation


protocol NetworkImageService {
    func fetchImages(_ success: ([Image]) -> Void, failure: (Error) -> Void)
}

class NetworkManager: NetworkImageService {
    func fetchImages(_ success: ([Image]) -> Void, failure: (Error) -> Void) {
        
        if let url = URL(string: "https://www.reddit.com/r/pics/.json?jsonp=") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
            }
            task.resume()
        } else {
            
        }
    }
}
