//
//  OtherPaymentCell.swift
//  Mackirel
//
//  Created by brian on 6/7/21.
//

import UIKit

class OtherPaymentCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lbPaymentLabel: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    var onCheck: (() -> ())?
    @IBAction func actionCheck(_ sender: Any) {
        self.onCheck?()
    }
}
