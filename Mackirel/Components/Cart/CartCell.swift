//
//  CartCell.swift
//  Mackirel
//
//  Created by brian on 6/6/21.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lbSubtotal: UILabel!
    
    @IBOutlet weak var lbQty: UILabel!
    
    var plus: (() -> ())?
    var minus: (() -> ())?
    var delete: (() -> ())?
    
    @IBAction func actionPlus(_ sender: Any) {
        self.plus?()
    }
    
    @IBAction func actionMinus(_ sender: Any) {
        self.minus?()
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        self.delete?()
    }
    
}
