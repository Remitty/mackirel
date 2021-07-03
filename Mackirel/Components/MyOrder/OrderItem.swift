//
//  OrderItem.swift
//  Mackirel
//
//  Created by brian on 6/16/21.
//

import UIKit

class OrderItem: UITableViewCell {
    @IBOutlet weak var lbOrderId: UILabel!
    
    @IBOutlet weak var lbProductCnt: UILabel!
    
    @IBOutlet weak var lbKind: UILabel!
    @IBOutlet weak var lbTotalPrice: UILabel!
    
    @IBOutlet weak var lbStatus: UILabel!
    
    @IBOutlet weak var lbDate: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBAction func actionConfirm(_ sender: Any) {
        self.onConfirm?()
    }
    
    var onConfirm: (() -> ())?
    
}
