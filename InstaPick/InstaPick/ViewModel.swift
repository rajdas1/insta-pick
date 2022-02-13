//
//  ViewModel.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import Foundation

protocol ImageListViewModelProtocol {
    var imageRepo: ImageStorable { get set }
    var imageService: NetworkImageService { get set }
    func fetchImages(_ completion: (() -> Void)?)
    var images: Observable<[Image]> { get set }
    var error: Observable<Error> { get set }
    var isLoading: Observable<Bool> { get set }
    var dateFormatter: DateFormatter { get set }
}

extension ImageListViewModelProtocol {
    func fetchImages(_ completion: (() -> Void)? = nil) {
        fetchImages(completion)
    }
}

class ImageListViewModel: ImageListViewModelProtocol {
    
    var images: Observable<[Image]> = Observable<[Image]>()
    var error: Observable<Error> = Observable<Error>()
    var isLoading: Observable<Bool> = Observable<Bool>()
    
    var imageService: NetworkImageService
    var imageRepo: ImageStorable
    var dateFormatter: DateFormatter
    
    init(_ service: NetworkImageService, imageRepository: ImageStorable, dateFormatter: DateFormatter, isLoading: Bool) {
        self.imageService = service
        self.isLoading.value = isLoading
        self.imageRepo = imageRepository
        self.dateFormatter = dateFormatter
    }
    
    func fetchImages(_ completion: (() -> Void)?) {
        imageService.fetchImages { (images) in
            self.images.value = images
            completion?()
        } failure: { (error) in
            self.error.value = error
            completion?()
        }
    }
}


