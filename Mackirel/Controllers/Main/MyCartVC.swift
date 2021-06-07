//
//  MyCartVC.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation
import UIKit

class MyCartVC: UIViewController {
    
    @IBOutlet weak var lbTotalPrice: UILabel!
    
    @IBOutlet weak var cartTable: UITableView! {
        didSet {
            cartTable.delegate = self
            cartTable.dataSource = self
            cartTable.showsVerticalScrollIndicator = false
            cartTable.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        }
    }
    
    @IBOutlet weak var cartTableHeight: NSLayoutConstraint!
    
    var cartList = [CartModel]()
    var total: Double = 0.0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartList = DBCart().getCartItems()
        for cart in cartList {
            total += cart.price * Double(cart.cartQty)
        }
        lbTotalPrice.text = PriceFormat(amount: total, currency: .usd).description
    }
    
    @IBAction func actionCheckout(_ sender: Any) {
        
    }
    
}

extension MyCartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            tableView.estimatedRowHeight = 180
            cartTableHeight.constant = CGFloat( Double(cartList.count) * 180)
            return cartList.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 180
        }
       

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: CartCell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
            let item = cartList[indexPath.row]
            cell.img.load(url: URL(string: item.image)!)
            cell.lbPrice.text = PriceFormat(amount: item.price, currency: .usd).description
            cell.lbQty.text = "\(item.cartQty!)"
            cell.lbTitle.text = item.title
            var count: Int = item.cartQty
            let subtotal: Double = item.price * Double(count)
            cell.lbSubtotal.text =  PriceFormat(amount: subtotal, currency: .usd).description
            
            cell.plus = {() in
                if item.cartQty == item.qty {
                    self.showToast(message: "Here is max")
                    return
                }
                count += 1
                if DBCart().updateCartItem(id: item.id, qty: count) {
                    let subtotal: Double = item.price * Double(count)
                    cell.lbSubtotal.text =  "\(subtotal)"
                    cell.lbQty.text = "\(count)"
                    
                    self.total += item.price
                    self.lbTotalPrice.text = PriceFormat(amount: self.total, currency: .usd).description
                }
            }
            
            cell.minus = {() in
                if count == 1 {
                    return
                }
                count -= 1
                if DBCart().updateCartItem(id: item.id, qty: count) {
                    let subtotal: Double = item.price * Double(count)
                    cell.lbSubtotal.text =  "\(subtotal)"
                    cell.lbQty.text = "\(count)"
                    
                    self.total -= item.price
                    self.lbTotalPrice.text = PriceFormat(amount: self.total, currency: .usd).description
                }
            }
            
            cell.delete = { () in
                let alert = Alert.showConfirmAlert(message: "Are you sure you want to delete this order?", handler: {_ in
                    if DBCart().deleteCartItem(id: item.id) {
                        
                        self.cartList.remove(at: indexPath.row)
                        self.cartTable.reloadData()
                        
                        self.total -= item.price * Double(count)
                        self.lbTotalPrice.text = PriceFormat(amount: self.total, currency: .usd).description
                    }
                })
                self.presentVC(alert)
            }
            
            return cell
        }
}
