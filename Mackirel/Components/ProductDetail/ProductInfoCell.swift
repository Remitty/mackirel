//
//  ProductInfoCell.swift
//  Mackirel
//
//  Created by brian on 5/29/21.
//

import Foundation
import UIKit

class ProductInfoCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblShip: UILabel!
    @IBOutlet weak var imgShip: UIImageView!
    
    
    
    @IBOutlet weak var btnPrice: UIButton! {
        didSet {
            btnPrice.layer.borderWidth = 1
//            btnPrice.layer.borderColor = .systemPurple
            btnPrice.layer.cornerRadius = 7
            btnPrice.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            let buttonTitleSize = btnPrice.currentTitle?.size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15+1)])
//            print(btnPrice.currentTitle!)
//            print(buttonTitleSize!)
//            btnPrice.frame.size.height = buttonTitleSize.height * 2
//            btnPrice.frame.size.width = (buttonTitleSize!.width) + 60
//            btnPrice.frame.origin.x = 30
        }
    }
    @IBOutlet weak var btnAddCart: UIButton!
    
    var addCart: (()->())?
    
    @IBAction func actionAddCart(_ sender: Any) {
        self.addCart?()
    }
}
