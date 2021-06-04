//
//  ImageSlideShowCell.swift
//  Mackirel
//
//  Created by brian on 5/31/21.
//

import Foundation
import Alamofire
import UIKit
import ImageSlideshow

class ImageSlideCell: UITableViewCell {
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    var sourceImages = [InputSource]()
    var localImages = [String]()
    
    
    func imageSliderSetting() {
        for image in localImages {
            let alamofireSource = AlamofireSource(urlString: image.encodeUrl())!
            sourceImages.append(alamofireSource)
        }
        self.slideshow.backgroundColor = UIColor.white
//        self.slideshow.slideshowInterval = 5.0
        self.slideshow.pageControlPosition = PageControlPosition.insideScrollView
        self.slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        self.slideshow.activityIndicator = DefaultActivityIndicator()
        self.slideshow.currentPageChanged = { page in
        }
        
        self.slideshow.setImageInputs(sourceImages)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
//        let fullScreenController = slideshow.presentFullScreenController(from: viewController()!) //me
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil) //me
    }
    
}
