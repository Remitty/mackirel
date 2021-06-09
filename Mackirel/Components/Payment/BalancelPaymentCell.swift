//
//  BalancelPaymentCell.swift
//  Mackirel
//
//  Created by brian on 6/7/21.
//

import UIKit

class BalancePaymentCell: UITableViewCell {
    
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    
    var onCheck: (() -> ())?
    
    @IBAction func actionCheck(_ sender: Any) {
        self.onCheck?()
    }
}
