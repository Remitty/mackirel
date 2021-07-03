//
//  CryptoVC.swift
//  Mackirel
//
//  Created by brian on 7/3/21.
//


import UIKit
import NVActivityIndicatorView

class CryptoVC: UIViewController, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var cryptoTable: UITableView! {
        didSet {
            cryptoTable.delegate = self
            cryptoTable.dataSource = self
            cryptoTable.showsVerticalScrollIndicator = false
            cryptoTable.separatorColor = UIColor.darkGray
            cryptoTable.separatorStyle = .singleLineEtched
            cryptoTable.register(UINib(nibName: "CoinItem", bundle: nil), forCellReuseIdentifier: "CoinItem")
        }
    }
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    @IBOutlet weak var constantTableHeight: NSLayoutConstraint!
    
    var cryptoList = [CoinModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.loadData()
       
    }
    
    func loadData() {
        self.startAnimating()
        let param : [String : Any] = [:]
        RequestHandler.getRequest(url: Constants.URL.GET_ALL_COINS, params: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var coin : CoinModel!
            
            if let coinData = dictionary["coins"] as? [[String:Any]] {
                self.cryptoList = [CoinModel]()
                
                for item in coinData {
                    coin = CoinModel(fromDictionary: item)
                    self.cryptoList.append(coin)
                }
                self.cryptoTable.reloadData()
            }
           
                
            }) { (error) in
                        self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func submitDeposit(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.postRequest(url: Constants.URL.COIN_DEPOSIT, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let address = dictionary["address"] as! String

            self.showAddressAlert(symbol: param["symbol"] as! String, address: address)
            
            
        }) {
            (error) in
                        self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func showAddressAlert(symbol : String, address: String) {
        let alertController = UIAlertController(title: "Send only \(symbol) to this address", message: nil, preferredStyle: .alert)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { (_) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = address
            self.showToast(message: "Copied successfully")
        }
        
        alertController.addTextField { (textField) in
            textField.text = address
        }
        alertController.addAction(copyAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alertController, animated: true, completion: nil)
    }

}

extension CryptoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.estimatedRowHeight = 50
        self.constantTableHeight.constant = CGFloat(Double(cryptoList.count) * 50.0)
        if cryptoList.count > 0 {
            self.lbEmpty.isHidden = true
        }
        print(cryptoList.count)
        return cryptoList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoinItem = tableView.dequeueReusableCell(withIdentifier: "CoinItem", for: indexPath) as! CoinItem
        
        let item = cryptoList[indexPath.row]
        
        cell.imgIcon.load(url: URL(string: item.icon)!)
        cell.lbName.text = item.name
        cell.lbPrice.text = item.price
        
        cell.onDeposit = { () in
            let parameter: NSDictionary = [
                "coin": item.id!,
                "symbol": item.symbol!
            ]
            self.submitDeposit(param: parameter)
        }
        

        return cell
    }
}

