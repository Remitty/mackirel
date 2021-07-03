//
//  CardVC.swift
//  Mackirel
//
//  Created by brian on 6/14/21.
//

import UIKit
import MaterialComponents
import Stripe
import NVActivityIndicatorView

class CardVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var cardView: MDCCard!
    
    @IBOutlet weak var cardTable: UITableView! {
        didSet{
            cardTable.dataSource = self
            cardTable.showsVerticalScrollIndicator = false
            cardTable.register(UINib(nibName: "CardItem", bundle: nil), forCellReuseIdentifier: "CardItem")
            cardTable.delegate = self
        }
    }
    
    @IBOutlet weak var cardTableHeight: NSLayoutConstraint!
    
    var cardList = [CardModel]()
    var withdrawal = 0
    var cvv, cardNo: String!
    var month, year: Int!
    let stripeWidget = STPPaymentCardTextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.addSubview(stripeWidget)
        let padding: CGFloat = 0
        stripeWidget.frame = CGRect(
            x: padding,
            y: padding,
            width: cardView.bounds.width - (padding * 2),
            height: 50)
        stripeWidget.postalCodeEntryEnabled = false
    }
    
    
    @IBAction func actionCardAdd(_ sender: Any) {
        if !stripeWidget.isValid {
            let alert = Alert.showBasicAlert(message: "Invalid card format")
            presentVC(alert)
            return
        }
        self.addCard()
    }
    
    func getCard() {
        let param : [String : Any] = ["withdrawal": self.withdrawal]
        self.startAnimating()
        RequestHandler.getRequest(url: Constants.URL.REQUEST_CARD, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var card : CardModel!
            
            if let data = dictionary["cards"] as? [[String:Any]] {
                self.cardList = [CardModel]()
                for item in data {
                    card = CardModel(fromDictionary: item)
                    self.cardList.append(card)
                }
                self.cardTable.reloadData()
            }
                    
           
            
            }) { (error) in
                self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    func addCard() {
        let param : [String : Any] = [
            "withdrawal": self.withdrawal,
            "no": self.cardNo!,
            "month": self.month!,
            "year": self.year!,
            "cvc": self.cvv!
        ]
        self.startAnimating()
        RequestHandler.postRequest(url: Constants.URL.REQUEST_CARD, params: param as NSDictionary, success: { (successResponse) in
             self.stopAnimating()
            
            self.getCard()

            self.showToast(message: "Added successfully")
            
            }) { (error) in
                self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                self.presentVC(alert)
            }
    }
    
    func removeCard(id: String, index: Int) {
        let param : [String : Any] = [
            "withdrawal": self.withdrawal,
            "id": id
        ]
        self.startAnimating()
        RequestHandler.deleteRequest(url: Constants.URL.REQUEST_CARD, params: param as NSDictionary, success: { (successResponse) in
                        self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            self.cardList.remove(at: index)

            self.cardTable.reloadData()
            
            self.showToast(message: "Deleted successfully")
            
            }) { (error) in
                self.stopAnimating()
                let alert = Alert.showBasicAlert(message: error.message)
                        self.presentVC(alert)
            }
    }
    
    
}


extension CardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cardTableHeight.constant = CGFloat(Double(cardList.count) * 50)
        return cardList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CardItem = tableView.dequeueReusableCell(withIdentifier: "CardItem", for: indexPath) as! CardItem
        let item = cardList[indexPath.row]
        cell.deleteCard = {() in
            self.removeCard(id: item.cardId, index: indexPath.row)
        }
        cell.id = item.cardId
        cell.index = indexPath.row
        cell.lbCardNo.text = item.lastFour
        if item.brand == "Visa" {
//            cell.imgIcon.set
        }
        
        
        return cell
    }
    
}

