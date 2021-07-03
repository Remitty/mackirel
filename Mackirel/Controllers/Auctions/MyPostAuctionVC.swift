//
//  MyPostAuctionVC.swift
//  Mackirel
//
//  Created by brian on 6/11/21.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class MyPostAuctionVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    var itemInfo: IndicatorInfo = "POST"
    
    @IBOutlet weak var auctionTable: UITableView! {
        didSet {
            auctionTable.delegate = self
            auctionTable.dataSource = self
            auctionTable.showsVerticalScrollIndicator = false
            auctionTable.separatorColor = UIColor.darkGray
            auctionTable.separatorStyle = .singleLineEtched
            auctionTable.register(UINib(nibName: "AuctionItem", bundle: nil), forCellReuseIdentifier: "AuctionItem")
        }
    }
    
    var auctionList = [AuctionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
}

extension MyPostAuctionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auctionList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
//        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AuctionItem = tableView.dequeueReusableCell(withIdentifier: "AuctionItem", for: indexPath) as! AuctionItem
        
        let product = auctionList[indexPath.row]
        cell.lbTitle.text = product.title
        cell.lbLocation.text = product.location
        
//        if product.isShipping {
//            cell.lbShippingPrice.text = product.shippingPrice
//        } else {
//            cell.shippingLayout.isHidden = true
//
//        }
        cell.lbBiddersCnt.text = product.biddersCnt
        cell.lbCatName.text = product.catName
        cell.lbStatus.text = product.status
        cell.lbStartTime.text = product.date
        cell.lbStartPrice.text = product.startPrice
        
        cell.remainingTime = product.duration
        cell.precessTimer()

        return cell
    }
}
