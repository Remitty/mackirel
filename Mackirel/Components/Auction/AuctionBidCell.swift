//
//  AuctionBidCell.swift
//  Mackirel
//
//  Created by brian on 6/10/21.
//

import UIKit

class AuctionBidCell: UITableViewCell {
    
    @IBOutlet weak var txtBidPrice: UITextField!
    
    @IBAction func actionBid(_ sender: Any) {
        self.onBid?()
    }
    
    var onBid : (() -> ())?
    
}
