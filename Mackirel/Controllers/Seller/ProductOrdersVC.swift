//
//  OrdersVC.swift
//  Mackirel
//
//  Created by brian on 7/2/21.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class ProductOrdersVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    var itemInfo: IndicatorInfo = "ORDERS"
    
    @IBOutlet weak var ordersTable: UITableView! {
        didSet {
            ordersTable.delegate = self
            ordersTable.dataSource = self
            ordersTable.showsVerticalScrollIndicator = false
            ordersTable.separatorColor = UIColor.darkGray
            ordersTable.separatorStyle = .singleLineEtched
            ordersTable.register(UINib(nibName: "SellerOrderItem", bundle: nil), forCellReuseIdentifier: "SellerOrderItem")
        }
    }
    
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var constantTableHeight: NSLayoutConstraint!
    
    var orderList = [OrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
}

extension ProductOrdersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.constantTableHeight.constant = CGFloat(orderList.count * 150)
        return orderList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = orderList[indexPath.row]
        return CGFloat(80 + item.orderProducts.count*60)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SellerOrderItem = tableView.dequeueReusableCell(withIdentifier: "SellerOrderItem", for: indexPath) as! SellerOrderItem
        
        let item = orderList[indexPath.row]
        
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

