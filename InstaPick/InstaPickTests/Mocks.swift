//
//  Mocks.swift
//  InstaPickTests
//
//  Created by Vyas, Rajat on 14/02/22.
//

import UIKit
@testable import InstaPick

struct ImageRespositoryMock: ImageStorable {
    func loadImage(for url: URL, completion: @escaping (UIImage, String) -> Void) {
        //
    }
}

struct NetworkServiceMock: NetworkImageService {
    func fetchImages(_ success: @escaping ([Image]) -> Void, failure: @escaping (Error) -> Void) {
        guard let path = Bundle(for: InstaPickTests.self).path(forResource: "image_service_mock", ofType: "json") else {
            failure(LocalError.badURL)
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let model = try JSONDecoder().decode(ImageResponse.self, from: data)
            success(model.images)
        } catch {
            failure(LocalError.parsingFailed(error))
        }
    }
}
