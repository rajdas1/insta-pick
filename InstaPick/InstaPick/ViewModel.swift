//
//  ViewModel.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import Foundation

struct Image {
    var title: String
    var timeStamp: String
    var thumbnailURL: String
    var imageURL: String
}

protocol ImageListViewModelProtocol {
    var imageService: NetworkImageService { get set }
    func fetchImages(_ completion: (() -> Void)?)
    var images: Observable<[Image]>? { get set }
    var error: Observable<Error>? { get set }
    var isLoading: Observable<Bool> { get set }
}

extension ImageListViewModelProtocol {
    func fetchImages(_ completion: (() -> Void)? = nil) {
        fetchImages(completion)
    }
}

class ImageListViewModel: ImageListViewModelProtocol {
    
    var images: Observable<[Image]>?
    var error: Observable<Error>? = Observable<Error>()
    var isLoading: Observable<Bool> = Observable<Bool>()
    
    var imageService: NetworkImageService
    
    init(_ service: NetworkImageService, isLoading: Bool) {
        self.imageService = service
        self.isLoading.value = isLoading
    }
    
    func fetchImages(_ completion: (() -> Void)?) {
        imageService.fetchImages { (images) in
            self.images?.value = images
            completion?()
        } failure: { (error) in
            self.error?.value = error
            completion?()
        }
    }
}


