//
//  SellerOrderItem.swift
//  Mackirel
//
//  Created by brian on 6/16/21.
//

import UIKit

class SellerOrderItem: UITableViewCell {
    @IBOutlet weak var lbOrderId: UILabel!
    
    @IBOutlet weak var productTable: UITableView! {
        didSet {
            productTable.delegate = self
            productTable.dataSource = self
            productTable.showsVerticalScrollIndicator = false
            productTable.separatorColor = UIColor.darkGray
            productTable.separatorStyle = .singleLineEtched
            productTable.register(UINib(nibName: "SellerOrderProductItem", bundle: nil), forCellReuseIdentifier: "SellerOrderProductItem")
        }
    }
    
    @IBOutlet weak var constantTableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lbTotalPrice: UILabel!
    
    @IBOutlet weak var lbStatus: UILabel!
    
    @IBOutlet weak var lbDate: UILabel!
  
    @IBAction func actionShipDetail(_ sender: Any) {
        self.onShip?()
    }
    
    @IBOutlet weak var shipView: UIView!
    
    var onShip: (() -> ())?
    
    var productList = [OrderProductModel]()
}


extension SellerOrderItem: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.constantTableHeight.constant = CGFloat(productList.count * 60)
        return productList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SellerOrderProductItem = tableView.dequeueReusableCell(withIdentifier: "SellerOrderProductItem", for: indexPath) as! SellerOrderProductItem
        
        let product = productList[indexPath.row]
    
        cell.lbCount.text = product.productCnt
        cell.lbTitle.text = product.product.title

        return cell
    }
}

