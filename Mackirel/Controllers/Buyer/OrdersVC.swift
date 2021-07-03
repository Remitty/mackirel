//
//  OrderVC.swift
//  Mackirel
//
//  Created by brian on 7/3/21.
//


import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class OrdersVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    var itemInfo: IndicatorInfo = "ORDERS"
    
    @IBOutlet weak var ordersTable: UITableView! {
        didSet {
            ordersTable.delegate = self
            ordersTable.dataSource = self
            ordersTable.showsVerticalScrollIndicator = false
            ordersTable.separatorColor = UIColor.darkGray
            ordersTable.separatorStyle = .singleLineEtched
            ordersTable.register(UINib(nibName: "OrderItem", bundle: nil), forCellReuseIdentifier: "OrderItem")
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

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.constantTableHeight.constant = CGFloat(orderList.count * 150)
        if orderList.count > 0 {
            self.lbEmpty.isHidden = true
        }
        return orderList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = orderList[indexPath.row]
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderItem = tableView.dequeueReusableCell(withIdentifier: "OrderItem", for: indexPath) as! OrderItem
        
        let item = orderList[indexPath.row]
        
        
        cell.lbOrderId.text = item.orderId
        cell.lbDate.text = item.date.date
        cell.lbStatus.text = item.status
        cell.lbTotalPrice.text = item.totalPrice
        cell.lbKind.text = item.kind
        cell.lbProductCnt.text = item.productCnt
        cell.onConfirm = {() in
                          
        }

        return cell
    }
}


