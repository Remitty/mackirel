//
//  ProductDetailVC.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import ImageSlideshow
import Alamofire
import AlamofireImage
import MapKit

class ProductDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable , SimilarProductsTableCellDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
//            tableView.estimatedRowHeight = UITableView.automaticDimension
            
        }
    }
    
    //MARK:- Properties
    let defaults = UserDefaults.standard
    var ad_id = 0
    
    var relatedAdsArray = [ProductModel]()
    var product: ProductModel!
    var owner: UserModel!
    
    
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
        let parameter: [String: Any] = ["product_id": ad_id]
        print(parameter)
        self.getDetail(param: parameter as NSDictionary)
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
            let cell: ImageSlideCell  = tableView.dequeueReusableCell(withIdentifier: "ImageSlideCell", for: indexPath) as! ImageSlideCell
            if product != nil {
                for item in product.images {
                    cell.localImages.append(item.thumb)
                }
                
                cell.imageSliderSetting()
            }
            return cell
        case 1:
            
            let cell: ProductInfoCell  = tableView.dequeueReusableCell(withIdentifier: "ProductInfoCell", for: indexPath) as! ProductInfoCell
            if product != nil {
                
                cell.lblTitle.text = product.title
                cell.lblState.text = product.location
                cell.lblAddress.text = product.address
                if product.isShipping {
                    cell.lblShip.text = "Ship for $\(product.shipPrice!)"
                } else {
                    cell.lblShip.isHidden = true
                    cell.imgShip.isHidden = true
                    cell.btnAddCart.isHidden = true
                }
                let btnPriceLabel: Double = product.price!
                cell.btnPrice.setTitle(PriceFormat(amount: product.price, currency: .usd).description, for: .normal)
                cell.addCart = {() in
                    if DBCart().addCartItem(product: self.product) {
                        cell.btnAddCart.isHidden = true
                        self.showToast(message: "Added into cart successfully")
                    }
                }
//                cell.btnPrice.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//                let buttonTitleSize = ("\(btnPriceLabel)" as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15+1)])
//                print(btnPriceLabel)
//                print(buttonTitleSize)
//    //            btnPrice.frame.size.height = buttonTitleSize.height * 2
//                cell.btnPrice.frame.size.width = buttonTitleSize.width + 60
//                cell.btnPrice.frame.origin.x = 30

//                yPos = yPos + (cell.btnPrice.frame.size.height) + 10

//                cell.btnPrice.frame.origin.y = yPos
            }
            return cell
        case 2:
            let cell: ProductSummaryCell  = tableView.dequeueReusableCell(withIdentifier: "ProductSummaryCell", for: indexPath) as! ProductSummaryCell
            if product != nil {
                
                cell.lblDescription.text = product.description
            }
            return cell
        case 3:
            let cell: MapCell  = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
            if product != nil {
                cell.lati = product.lat
                cell.long = product.long
                cell.checkLocationServices()
            }
            return cell
        case 4:
            let cell: SimilarProductsTableCell  = tableView.dequeueReusableCell(withIdentifier: "SimilarProductsTableCell", for: indexPath) as! SimilarProductsTableCell
                cell.delegate = self
                cell.relatedAddsArray = self.relatedAdsArray
                
                cell.collectionView.reloadData()
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
            height = 150
//            height = UITableView.automaticDimension
            break
        case 2:
            height = 100
//            height = UITableView.automaticDimension
            break
        case 3:
            height = 120
            break
        case 4:
            height = 100
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
    func getDetail(param: NSDictionary) {
        self.startAnimating()
        RequestHandler.getRequestWithoutAuth(url: Constants.URL.GET_PRODUCT_DETAIL, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let data = dictionary["data"] as! [String: Any]
            self.product = ProductModel(fromDictionary: data)
            
            self.owner = UserModel(fromDictionary: dictionary["owner"] as! [String: Any])
            
            var product: ProductModel!
            
            if let related = dictionary["related_products"] as? [[String: Any]] {
                self.relatedAdsArray = [ProductModel]()
                for item in related {
                    product = ProductModel(fromDictionary: item)
                    self.relatedAdsArray.append(product)
                }
                
            }
            self.tableView.reloadData()
                    
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
       
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
