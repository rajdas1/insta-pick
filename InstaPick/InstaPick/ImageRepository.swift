//
//  ImageRepository.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 13/02/22.
//

import UIKit

protocol ImageStorable {
    func loadImage(for url: URL, completion: @escaping (UIImage, String) -> Void)
}

struct ImageRepository: ImageStorable {
    
    private static var cache = NSCache<NSString, UIImage>()
    
    func loadImage(for url: URL, completion: @escaping (UIImage, String) -> Void) {
       
        if let cachedImage = ImageRepository.cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, url.absoluteString)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            if let downloadedImage = UIImage(data: data) {
                ImageRepository.cache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                completion(downloadedImage, url.absoluteString)
            }
        }.resume()
    }
}
