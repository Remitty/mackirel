//
//  MyProductItem.swift
//  Mackirel
//
//  Created by brian on 6/15/21.
//

import UIKit

class MyProductItem: UICollectionViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UIButton!
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var shipView: UIView!
    
    @IBOutlet weak var lbShipPrice: UILabel!
    
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var lbTimer: UILabel!
    
    var timer = Timer()
    var remainTime = 0
    
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
