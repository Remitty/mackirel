//
//  AuctionItem.swift
//  Mackirel
//
//  Created by brian on 6/11/21.
//

import UIKit

class AuctionItem: UITableViewCell {
    
    
    var id: String!
    var remainingTime = 0
    var timer = Timer()
    
    @IBOutlet weak var lbStartPrice: UILabel!
    @IBOutlet weak var lbBidPrice: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCatName: UILabel!
    @IBOutlet weak var lbRemainTime: UILabel!
    @IBOutlet weak var lbStartTime: UILabel!
    
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbBiddersCnt: UILabel!
 
    
    var onCancel: (() -> ())?
    
    @IBAction func actionCancel(_ sender: Any) {
        let param = ["id": self.id] as! NSDictionary
        self.onCancel?()
    }
    
    func precessTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AuctionItem.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            let days = getStringFrom(seconds: (remainingTime / 3600 / 24))
            let hours = getStringFrom(seconds: ((remainingTime / 3600) % 24))
            let minutes = getStringFrom(seconds: ((remainingTime % 3600) / 60))
            let seconds = getStringFrom(seconds: ((remainingTime % 3600) % 60))
            
            lbRemainTime.text="\(days) D \(hours) H \(minutes) M \(seconds) S"
            
        } else {
            timer.invalidate()
        }
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
}
