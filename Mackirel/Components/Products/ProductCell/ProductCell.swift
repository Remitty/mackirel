//
//  ProductCell.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation
import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView! {
        didSet{
            imgPicture.layer.cornerRadius = 10
            imgPicture.clipsToBounds = true
        }
    }
    
    //MARK:- Properties
    
    var btnActionFull: (()->())?
    
    @IBAction func actionBigbutton(_ sender: Any) {
        self.btnActionFull?()
    }
}
