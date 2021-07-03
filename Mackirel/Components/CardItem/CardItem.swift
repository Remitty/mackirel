//
//  CardItem.swift
//  Mackirel
//
//  Created by brian on 6/14/21.
//

import Foundation
import UIKit

class CardItem: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var lbCardNo: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    var id: String!
    var index: Int!
    
    var deleteCard: (() -> ())?
    
    @IBAction func actionRemove(_ sender: Any) {
        
        self.deleteCard?()
    }
}
