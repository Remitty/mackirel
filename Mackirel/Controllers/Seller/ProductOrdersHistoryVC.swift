//
//  OrdersHistoryVC.swift
//  Mackirel
//
//  Created by brian on 7/2/21.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class ProductOrdersHistoryVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    var itemInfo: IndicatorInfo = "ORDER HISTORY"
    
    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "SellerOrderItem", bundle: nil), forCellReuseIdentifier: "SellerOrderItem")
        }
    }
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    @IBOutlet weak var constantTableHeight: NSLayoutConstraint!
    
    var historyList = [OrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
}

extension ProductOrdersHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.constantTableHeight.constant = CGFloat(historyList.count * 150)
        if historyList.count > 0 {
            self.lbEmpty.isHidden = true
        }
        return historyList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = historyList[indexPath.row]
        return CGFloat(80 + item.orderProducts.count*60)

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SellerOrderItem = tableView.dequeueReusableCell(withIdentifier: "SellerOrderItem", for: indexPath) as! SellerOrderItem
        
        let item = historyList[indexPath.row]
        
        cell.productList = item.orderProducts
        cell.lbOrderId.text = item.orderId
        cell.lbDate.text = item.date.date
        cell.lbStatus.text = item.status
        cell.lbTotalPrice.text = item.totalPrice
        cell.onShip = { () in
            
        }
        

        return cell
    }
}
