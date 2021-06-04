//
//  UploadImageCell.swift
//  Mackirel
//
//  Created by brian on 5/31/21.
//

import UIKit

class UploadImageCell: UITableViewCell {

    
    @IBOutlet weak var imgCamera: UIImageView!
    
    //MARK:- Properties
    var btnUploadImage : (()->())?
    var btnNext : (()->())?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func actionUploadImages(_ sender: Any) {
        self.btnUploadImage?()
    }
    
    @IBAction func actionNext(_ sender: Any) {
        self.btnNext?()
    }
}
