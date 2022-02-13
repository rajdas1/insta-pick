//
//  ImageListCell.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 13/02/22.
//

import UIKit

class ImageListCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnail.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func set(_ data: Image, imageRepo: ImageStorable?, dateFormatter: DateFormatter?) {
        titleLabel.text = data.title
        timestampLabel.text = dateFormatter?.string(from: data.timeStamp)
        
        guard let imageURL = data.thumbnailURL else {
            return
        }
        imageRepo?.loadImage(for: imageURL) { [weak self] (image, urlString) in
            if urlString == imageURL.absoluteString {
                DispatchQueue.main.async {
                    self?.thumbnail.image = image
                }
            }
        }
    }
    
}
