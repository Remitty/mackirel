//
//  PaymentVC.swift
//  Mackirel
//
//  Created by brian on 6/7/21.
//

import Foundation
import UIKit

class PaymentVC: UIViewController {
    
    @IBOutlet weak var lbSubtotal: UILabel!
    @IBOutlet weak var lbTax: UILabel!
    @IBOutlet weak var lbShipping: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
 
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.showsVerticalScrollIndicator = false
            tableView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "BalancePaymentCell")
            tableView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "OtherPaymentCell")
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOrder: UIButton!
    
    var balance = 0.0
    var option = 0
    var shippingAddress: ShippingModel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
    }
    
    @IBAction func actionOrder(_ sender: Any) {
    }
    
}

extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView.estimatedRowHeight = 15
//        bidTableHeightLayout.constant = CGFloat( Double(bidList.count) * 15.0)
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.option = indexPath.row
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch(indexPath.row) {
        case 0:
            let cell: BalancePaymentCell = tableView.dequeueReusableCell(withIdentifier: "BalancePaymentCell", for: indexPath) as! BalancePaymentCell
            cell.lbBalance.text = PriceFormat(amount: balance, currency: .usd).description
            cell.onCheck = {() in
                self.option = 0
                self.tableView.reloadData()
            }
            if option == 0 {
                cell.btnCheck.tintColor = .systemGreen
            }
            return cell
        case 1:
            let cell: OtherPaymentCell = tableView.dequeueReusableCell(withIdentifier: "OtherPaymentCell", for: indexPath) as! OtherPaymentCell
            cell.lbPaymentLabel.text = "Card"
//            cell.logo.image = UIImage(systemName: "")
            cell.onCheck = {() in
                self.option = 1
                self.tableView.reloadData()
            }
            if option == 1 {
                cell.btnCheck.tintColor = .systemGreen
            }
            return cell
        case 2:
            let cell: OtherPaymentCell = tableView.dequeueReusableCell(withIdentifier: "OtherPaymentCell", for: indexPath) as! OtherPaymentCell
            cell.lbPaymentLabel.text = "Paypal"
//            cell.logo.image = UIImage(systemName: "")
            cell.onCheck = {() in
                self.option = 2
                self.tableView.reloadData()
            }
            if option == 2 {
                cell.btnCheck.tintColor = .systemGreen
            }
            return cell
        case 3:
            let cell: OtherPaymentCell = tableView.dequeueReusableCell(withIdentifier: "OtherPaymentCell", for: indexPath) as! OtherPaymentCell
            cell.lbPaymentLabel.text = "AliPay"
//            cell.logo.image = UIImage(systemName: "")
            cell.onCheck = {() in
                self.option = 3
                self.tableView.reloadData()
            }
            if option == 3 {
                cell.btnCheck.tintColor = .systemGreen
            }
            return cell
        case 4:
            let cell: OtherPaymentCell = tableView.dequeueReusableCell(withIdentifier: "OtherPaymentCell", for: indexPath) as! OtherPaymentCell
            cell.lbPaymentLabel.text = "WechatPay"
//            cell.logo.image = UIImage(systemName: "")
            cell.onCheck = {() in
                self.option = 4
                self.tableView.reloadData()
            }
            if option == 4 {
                cell.btnCheck.tintColor = .systemGreen
            }
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
}
