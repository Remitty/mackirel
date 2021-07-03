//
//  AuctionTimerCell.swift
//  Mackirel
//
//  Created by brian on 6/10/21.
//

import UIKit

class AuctionTimerCell: UITableViewCell {
    
    var timer = Timer()
    var remainTime = 0
    
    @IBOutlet weak var lbTimer: UILabel!
    
    func precessTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AuctionTimerCell.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if remainTime > 0 {
            remainTime -= 1
            let days = getStringFrom(seconds: (remainTime / 3600 / 24))
            let hours = getStringFrom(seconds: ((remainTime / 3600) % 24))
            let minutes = getStringFrom(seconds: ((remainTime % 3600) / 60))
            let seconds = getStringFrom(seconds: ((remainTime % 3600) % 60))
            
            lbTimer.text="\(days) D \(hours) H \(minutes) M \(seconds) S"
            
        } else {
            timer.invalidate()
        }
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
}
