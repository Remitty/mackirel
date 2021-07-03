//
//  OrderHistoryVC.swift
//  Mackirel
//
//  Created by brian on 7/3/21.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class OrdersHistoryVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    var itemInfo: IndicatorInfo = "ORDER HISTORY"
    
    @IBOutlet weak var historyTable: UITableView! {
        didSet {
            historyTable.delegate = self
            historyTable.dataSource = self
            historyTable.showsVerticalScrollIndicator = false
            historyTable.separatorColor = UIColor.darkGray
            historyTable.separatorStyle = .singleLineEtched
            historyTable.register(UINib(nibName: "OrderItem", bundle: nil), forCellReuseIdentifier: "OrderItem")
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

extension OrdersHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.constantTableHeight.constant = CGFloat(historyList.count * 150)
        return historyList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = historyList[indexPath.row]
        return CGFloat(80 + item.orderProducts.count*60)

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderItem = tableView.dequeueReusableCell(withIdentifier: "OrderItem", for: indexPath) as! OrderItem
        
        let item = historyList[indexPath.row]
        
        cell.lbOrderId.text = item.orderId
        cell.lbDate.text = item.date.date
        cell.lbStatus.text = item.status
        cell.lbTotalPrice.text = item.totalPrice
        cell.lbKind.text = item.kind
        cell.lbProductCnt.text = item.productCnt
        cell.btnConfirm.isHidden = true
        

        return cell
    }
}
