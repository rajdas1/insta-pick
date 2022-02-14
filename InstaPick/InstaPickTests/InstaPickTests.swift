//
//  InstaPickTests.swift
//  InstaPickTests
//
//  Created by Vyas, Rajat on 12/02/22.
//

import XCTest
@testable import InstaPick

class InstaPickTests: XCTestCase {

    var viewModel: ImageListAndSearchProtocol!
    var controller: ImageListViewController!
    var dateFormatter: DateFormatter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: "ImageListViewController")
        viewModel = ImageListViewModel(
            NetworkServiceMock(),
            imageRepository: ImageRespositoryMock(),
            dateFormatter: dateFormatter,
            isLoading: false)
        controller.viewModel = viewModel
        controller.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        controller = nil
        dateFormatter = nil
        try super.tearDownWithError()
    }

    func testParsedData() {
        sleep(2) // Wait until mock api call is complete in setup
        
        // Test Data
        let imageTitle = "[OC] sex is cool, but have you ever had your wife come home with a make-a-wish kid sized Lego haul?"
        let imageAuthor = "t2_21a9m8cx"
        let imageCreatedDate = Date(timeIntervalSince1970: 1644619328)
        let imageURL = "https://i.redd.it/c5rnhrz38ah81.jpg"
        let thumbnailURL = "https://a.thumbs.redditmedia.com/B3ELNMccv95-DIgmtn9Diudvfzy3eRgVw3oQlHTMYf4.jpg"
        
        // Actual
        let model = self.viewModel.filteredImages.value?[5]
        
        // Compare
        XCTAssert(imageTitle == model?.title)
        XCTAssert(imageAuthor == model?.author)
        XCTAssert(imageCreatedDate == model?.timeStamp)
        XCTAssert(imageURL == model?.imageURL?.absoluteString)
        XCTAssert(thumbnailURL == model?.thumbnailURL?.absoluteString)
    }
    
    func testImageListCell() {
        sleep(2) // Wait until mock api call is complete in setup
        
        // Test Data
        let imageModel = self.viewModel.filteredImages.value?[0]
        
        // Actual
        let cell = self.controller.tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? ImageListCell
        cell?.set(imageModel!, imageRepo: self.viewModel.imageRepo, dateFormatter: self.viewModel.dateFormatter)
        
        // Compare
        XCTAssert(cell?.titleLabel.text == imageModel?.title)
        XCTAssert(cell?.timestampLabel.text == self.dateFormatter.string(from: imageModel!.timeStamp))
    }
}
