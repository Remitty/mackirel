//
//  MyListPagerVC.swift
//  Mackirel
//
//  Created by brian on 6/16/21.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class SellerPagerVC: SegmentedPagerTabStripViewController, NVActivityIndicatorViewable {
    var isReload = false
    var productList = [ProductModel]()
    var orderList = [OrderModel]()
    var historyList = [OrderModel]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        settings.style.segmentedControlColor = .green
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.looadData()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        

        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "MyProductsVC") as! MyProductsVC
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "ProductOrdersVC") as! ProductOrdersVC
        let child3 = self.storyboard?.instantiateViewController(withIdentifier: "ProductOrdersHistoryVC") as! ProductOrdersHistoryVC
        
        
        child1.productList = productList
        child2.orderList = orderList
        child3.historyList = historyList
        
        return [child1, child2, child3]

        
    }
    
    func looadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        self.startAnimating()
        RequestHandler.getRequest(url: Constants.URL.SELLER_PRODUCT_LIST, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var product : ProductModel!
            var order: OrderModel!
            
            if let data = dictionary["productlist"] as? [[String:Any]] {
                
                self.productList = [ProductModel]()
                
                for item in data {
                    product = ProductModel(fromDictionary: item)
                    self.productList.append(product)
                }
            }
            if let data = dictionary["orderlist"] as? [[String:Any]] {
                
                self.orderList = [OrderModel]()
                
                for item in data {
                    order = OrderModel(fromDictionary: item)
                    if order.status == "Processing" {
                        self.orderList.append(order)
                    } else {
                        self.orderList.append(order)
                    }
                    
                }
            }
            if let data = dictionary["wining_auction"] as? [[String:Any]] {
                
                self.historyList = [OrderModel]()
                
                for item in data {
                    order = OrderModel(fromDictionary: item)
                    self.historyList.append(order)
                }
            }
            
            
            self.reloadPagerTabStripView()
                    
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
        
    }
    
    
}

