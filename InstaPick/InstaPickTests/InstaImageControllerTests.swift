//
//  InstaImageControllerTests.swift
//  InstaPickTests
//
//  Created by Vyas, Rajat on 14/02/22.
//

import XCTest
@testable import InstaPick

class InstaImageControllerTests: XCTestCase {

    var viewModel: ImageViewModel!
    var controller: ImageViewController!
    var dateFormatter: DateFormatter!
    
    var model: Image {
        let imageTitle = "[OC] sex is cool, but have you ever had your wife come home with a make-a-wish kid sized Lego haul?"
        let imageAuthor = "t2_21a9m8cx"
        let imageURL = "https://i.redd.it/c5rnhrz38ah81.jpg"
        let thumbnailURL = "https://a.thumbs.redditmedia.com/B3ELNMccv95-DIgmtn9Diudvfzy3eRgVw3oQlHTMYf4.jpg"
        
        let data = ImageResponse.Children.Data.ImageData(
            created: 1644619328,
            title: imageTitle,
            url: imageURL,
            thumbnail: thumbnailURL,
            author_fullname: imageAuthor
        )
        let image = ImageResponse.Children.Data(data: data)
        return Image(response: image)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        let storyboard = UIStoryboard(name: "ImageView", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: "ImageViewController")
        viewModel = ImageViewModel(image: model, imageRepo: ImageRespositoryMock(), dateFormatter: dateFormatter)
        controller.viewModel = viewModel
        controller.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        controller = nil
        dateFormatter = nil
        try super.tearDownWithError()
    }
    
    func testController() {
        XCTAssert(controller.titleLabel.text == "[OC] sex is cool, but have you ever had your wife come home with a make-a-wish kid sized Lego haul?")
        XCTAssert(controller.timeLabel.text == "Created at \(dateFormatter.string(from: Date(timeIntervalSince1970: 1644619328)))")
        XCTAssert(controller.authorLabel.text == "by t2_21a9m8cx")
    }
}
