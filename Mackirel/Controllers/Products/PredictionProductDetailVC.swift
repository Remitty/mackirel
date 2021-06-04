//
//  PredictionProductDetailVC.swift
//  Mackirel
//
//  Created by brian on 5/29/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import ImageSlideshow
import Alamofire
import AlamofireImage
import MapKit

class PredictionProductDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable , SimilarProductsTableCellDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            
        }
    }
   
    //MARK:- Properties
    let defaults = UserDefaults.standard
    var ad_id = 0
    var isFromMyAds = false
    var isFromInactiveAds = false
    var isFromFeaturedAds = false
    var isFromFavAds = false
    var sendMsgbuttonType = ""
    var similarAdsTitle = ""
    var ratingReviewTitle = ""
    var buttonText = ""
    var isShowAdTime = false
    var isRatingSectionShow = false
    
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    
    var relatedAdsArray = [ProductModel]()
    var product: ProductModel!
   
    var mutableString = NSMutableAttributedString()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.hideKeyboard()
        
        self.googleAnalytics(controllerName: "Add Detail Controller")
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.NotificationName.updateAddDetails), object: nil, queue: nil) { (notification) in
//            let parameter: [String: Any] = ["ad_id": self.ad_id]
//            print(parameter)
//            self.addDetail(param: parameter as NSDictionary)
//        }
        let parameter: [String: Any] = ["ad_id": ad_id]
        print(parameter)
        self.addDetail(param: parameter as NSDictionary)
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    //MARK:- Similar Ads Delegate Move Forward From collection View
    func goToDetailProduct(id: Int) {
        print("detail\(id)")
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        addDetailVC.ad_id = id
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        
        case 0:
            break
        case 1:
            
                let cell: ProductsTableCell  = tableView.dequeueReusableCell(withIdentifier: "ProductsTableCell", for: indexPath) as! ProductsTableCell

//                cell.delegate = self
//                cell.dataArray = self.latestArray
//                cell.lblSectionTitle.text = self.animalSectionTitle
//                cell.collectionView.reloadData()
                return cell
        case 2:
        break
        
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height: CGFloat = 0
        
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        
        
        return height
    }
    
    
    //MARK:- IBActions
    
    @IBAction func actionSendMessage(_ sender: Any) {
      
        if defaults.bool(forKey: "isLogin") == false {
            if let msg = defaults.string(forKey: "notLogin") {
                let alert = Alert.showBasicAlert(message: msg)
                self.presentVC(alert)
            }
        } else {
            
//                let msgVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
//                msgVC.isFromAdDetail = true
//                self.navigationController?.pushViewController(msgVC, animated: true)
            
        }
    }
    
    @IBAction func actionCallNow(_ sender: UIButton) {
        
    }
    
    //MARK:- API Call
    func addDetail(param: NSDictionary) {
        self.showLoader()
       
    }
    
    @objc func reloadTable(){
        self.tableView.reloadData()
    }
 
    //Make Add Favourite
    func makeAddFavourite(param: NSDictionary) {
        self.showLoader()
//        AddsHandler.makeAddFavourite(parameter: param, success: { (successResponse) in
//            self.stopAnimating()
//            if successResponse.success {
//                let alert = Constants.showBasicAlert(message: successResponse.message)
//                self.presentVC(alert)
//            }
//            else {
//                let alert = Constants.showBasicAlert(message: successResponse.message)
//                self.presentVC(alert)
//            }
//        }) { (error) in
//            self.stopAnimating()
//            let alert = Constants.showBasicAlert(message: error.message)
//            self.presentVC(alert)
//        }
    }
    
}
