//
//  CoinItem.swift
//  Mackirel
//
//  Created by brian on 7/3/21.
//

import UIKit

class CoinItem: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBAction func actionDeposit(_ sender: Any) {
        self.onDeposit?()
    }
    
    var onDeposit: (() -> ())?
    
}
