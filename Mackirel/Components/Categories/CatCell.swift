//
//  CatCell.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation
import UIKit

class CatCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgPicture: UIImageView! {
        didSet {
            imgPicture.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgContainer: UIView! {
        didSet {
            
//            imgContainer.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    var btnFullAction: (()->())?
    
    
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
}
