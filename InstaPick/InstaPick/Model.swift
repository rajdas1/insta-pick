//
//  Model.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 13/02/22.
//

import Foundation

struct Image {
    let title: String
    let timeStamp: Date
    let thumbnailURL: URL?
    let imageURL: URL?
    let author: String
    
    init(response: ImageResponse.Children.Data) {
        title = response.data.title
        timeStamp = Date(timeIntervalSince1970: TimeInterval(response.data.created))
        imageURL = URL(string: response.data.url)
        thumbnailURL = URL(string: response.data.thumbnail)
        author = response.data.author_fullname
    }
}

 /*
 {
    "kind": "Listing"
    "data": {
        "children": [
            {
                "created": 1644714937,
                "title": "[OC] Just put together my Husband’s Valentines’s Day gift",
                "url": "https://i.redd.it/m8x6dsre4ih81.jpg",
                "thumbnail": "https://b.thumbs.redditmedia.com/dJ6WBetH7XuyCjh9RIkfOEyuBxHW3d_yU0yGLL6-eJU.jpg",
                "author_fullname": "some guy"
            }
        ]
    }
 }
 */

struct ImageResponse: Decodable {
    let data: Children
    
    struct Children: Decodable {
        let children: [Data]
        
        struct Data: Decodable {
            let data: ImageData
            
            struct ImageData: Decodable {
                let created: TimeInterval
                let title: String
                let url: String
                let thumbnail: String
                let author_fullname: String
            }
        }
    }
}


extension ImageResponse {
    var images: [Image] {
        data.children.map(Image.init)
    }
}

