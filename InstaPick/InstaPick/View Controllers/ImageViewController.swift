//
//  ImageViewController.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 14/02/22.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var viewModel: ImageViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = viewModel else {
            return
        }
        titleLabel.text = model.image.title
        authorLabel.text = "by \(model.image.author)"
        timeLabel.text = "Created at \(model.dateFormatter.string(from: model.image.timeStamp))"
        
        if let url = model.image.imageURL {
            model.imageRepo.loadImage(for: url, completion: { [weak self] (image, _) in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.activity.stopAnimating()
                }
            })
        }
    }
}
