//
//  LeftMenuCell.swift
//  Mackirel
//
//  Created by brian on 5/19/21.
//

import Foundation
import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
