//
//  ImageVIew+.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/28.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setupMovieImage(from imageUrlString: String) {
        let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 90))
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: URL(string: imageUrlString),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
    }
}
