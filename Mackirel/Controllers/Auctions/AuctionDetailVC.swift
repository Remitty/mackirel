//
//  AuctionDetailVC.swift
//  Mackirel
//
//  Created by brian on 6/10/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import ImageSlideshow
import Alamofire
import AlamofireImage
import MapKit

class AuctionDetailVC: UIViewController, NVActivityIndicatorViewable {

    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
//            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.register(UINib(nibName: "AuctionInfoCell", bundle: nil), forCellReuseIdentifier: "AuctionInfoCell")
            tableView.register(UINib(nibName: "BidPriceCell", bundle: nil), forCellReuseIdentifier: "BidPriceCell")
            tableView.register(UINib(nibName: "AuctionTimerCell", bundle: nil), forCellReuseIdentifier: "AuctionTimerCell")
            tableView.register(UINib(nibName: "AuctionBidCell", bundle: nil), forCellReuseIdentifier: "AuctionBidCell")
        }
    }
    
    //MARK:- Properties
    let defaults = UserDefaults.standard
    var ad_id = 0
    
    var product: AuctionModel!
    var owner: UserModel!
    var userAuth: UserAuthModel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.hideKeyboard()
        
        self.googleAnalytics(controllerName: "auction Detail Controller")
        
        let data = UserDefaults.standard.object(forKey: "userAuthData")
        let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
        userAuth = UserAuthModel(fromDictionary: objUser)

        let parameter: [String: Any] = ["id": ad_id]
        print(parameter)
        self.getDetail(param: parameter as NSDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    //MARK:- API Call
    func getDetail(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.getRequestWithoutAuth(url: Constants.URL.GET_AUCTION_DETAIL, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let data = dictionary["data"] as! [String: Any]
            self.product = AuctionModel(fromDictionary: data)
            
            self.tableView.reloadData()
                    
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
       
    }
    
    @objc func reloadTable(){
        self.tableView.reloadData()
    }
   
 
}

extension AuctionDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        
        case 0:
            let cell: ImageSlideCell  = tableView.dequeueReusableCell(withIdentifier: "ImageSlideCell", for: indexPath) as! ImageSlideCell
            if product != nil {
                for item in product.images {
                    cell.localImages.append(item.thumb)
                }
                
                cell.imageSliderSetting()
            }
            return cell
        case 1:
            
            let cell: AuctionInfoCell  = tableView.dequeueReusableCell(withIdentifier: "AuctionInfoCell", for: indexPath) as! AuctionInfoCell
            if product != nil {
                
                cell.lbTitle.text = product.title
                cell.lbLocation.text = product.location
                
                if product.isShipping {
                    cell.lbShippingPrice.text = product.shippingPrice
                } else {
                    cell.shippingLayout.isHidden = true
                    
                }
                cell.lbBidderCnt.text = product.biddersCnt
                cell.lbCat.text = product.catName
                cell.lbStatus.text = product.status
                cell.lbStartTime.text = product.date
                cell.lbStartPrice.text = product.startPrice
            }
            return cell
        case 2:
            let cell: ProductSummaryCell  = tableView.dequeueReusableCell(withIdentifier: "ProductSummaryCell", for: indexPath) as! ProductSummaryCell
            if product != nil {
                
                cell.lblDescription.text = product.description
            }
            return cell
        case 3:
            let cell: BidPriceCell  = tableView.dequeueReusableCell(withIdentifier: "BidPriceCell", for: indexPath) as! BidPriceCell
            if product != nil {
                cell.lbBidPrice.text = product.highPrice
                cell.lbWinner.text = product.winnerName
                if product.winnerId == userAuth.id {
                    cell.lbWinner.text = "You winning"
                }
            }
            return cell
        case 4:
            let cell: AuctionTimerCell  = tableView.dequeueReusableCell(withIdentifier: "AuctionTimerCell", for: indexPath) as! AuctionTimerCell
            if product != nil {
                cell.remainTime = product.duration
                cell.precessTimer()
            }
            return cell
        case 5:
            let cell: AuctionBidCell  = tableView.dequeueReusableCell(withIdentifier: "AuctionBidCell", for: indexPath) as! AuctionBidCell
            cell.onBid = {() in
                guard let price = cell.txtBidPrice.text else {
                    return
                }
                if price.isEmpty {
                    cell.txtBidPrice.shake()
                    return
                }
                
                self.startAnimating()
                let param = [
                    "price": price,
                    "id": self.product.id
                ] as! NSDictionary
                RequestHandler.postRequest(url: Constants.URL.BET_AUCTION, params: param as NSDictionary, success: { (successResponse) in
                    self.stopAnimating()
                    let dictionary = successResponse as! [String: Any]
                    
                    self.product = AuctionModel(fromDictionary: dictionary["auction"] as! [String : Any])
                    
                    tableView.reloadData()
                    self.showToast(message: dictionary["message"] as! String)
                            
                }) { (error) in
                    let alert = Alert.showBasicAlert(message: error.message)
                            self.presentVC(alert)
                }
                
            }
            return cell
        
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height: CGFloat = 0
        
        switch section {
        case 0:
            height = 350
            break
        case 1:
            height = 185
//            height = UITableView.automaticDimension
            break
        case 2:
            height = 100
//            height = UITableView.automaticDimension
            break
        case 3:
            height = 100
            break
        case 4:
            height = 80
            break
        case 5:
            height = 90
            if product != nil {
                if product.winnerId == userAuth.id {
                    height = 0
                }
            }
            break
        default:
            break
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        
        return height
    }
}
