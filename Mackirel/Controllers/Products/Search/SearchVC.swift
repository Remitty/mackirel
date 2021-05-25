//
//  SearchVC.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

import UIKit
import NVActivityIndicatorView
import DropDown
import Firebase

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
  
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
    var categoryID = 0
    var isFromLocation = false
    
    var dataArray = [ProductModel]()
    var categotyAdArray = [CatModel]()
    
    var currentPage = 0
    var maximumPage = 0
    
    var featureAddTitle = ""
    var addcategoryTitle = ""
    let defaults = UserDefaults.standard
    var orderArray = [String]()
    var orderKeysArray = [String]()
    var orderName = ""
    
    var isFromAdvanceSearch = false
    var isFromNearBySearch = false
    var isFromTextSearch = false
    var searchText = ""
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var nearByDistance: CGFloat = 0.0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.googleAnalytics(controllerName: "Category Controller")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
//        if isFromAdvanceSearch {
//            self.dataArray = AddsHandler.sharedInstance.objCategoryArray
//            self.categotyAdArray = AddsHandler.sharedInstance.objCategotyAdArray
//            print(self.categotyAdArray)
//            self.tableView.reloadData()
//        } else
        
            if isFromNearBySearch {
            let param: [String: Any] = ["nearby_latitude": latitude, "nearby_longitude": longitude, "nearby_distance": nearByDistance, "page_number": 1]
            print(param)
            self.categoryData(param: param as NSDictionary)
        } else if isFromTextSearch {
            let param: [String: Any] = ["ad_title": searchText , "page_number": 1]
            print(param)
            self.categoryData(param: param as NSDictionary)
        } else if isFromLocation {
            let param: [String: Any] = ["ad_country" : categoryID]
            print(param)
            self.categoryData(param: param as NSDictionary)
        } else {
            let param: [String: Any] = ["ad_cats1" : categoryID, "page_number": 1]
            print(param)
            self.categoryData(param: param as NSDictionary)
        }
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    func paramData(param: NSDictionary) {
        self.categoryData(param: param)
    }
    
    func goToDetailController(id: Int) {
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        addDetailVC.ad_id = id
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    //MARK:- Table View Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 1 {
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            addDetailVC.ad_id = dataArray[indexPath.row].id
            self.navigationController?.pushViewController(addDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["ad_cats1" : categoryID, "page_number": currentPage]
            print(param)
            self.loadMoreData(param: param as NSDictionary)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = Bundle.main.loadNibNamed("CustomHeader", owner: self, options: nil)?.first as! CustomHeader
//        switch section {
//        case 0:
//            headerView.imgIcon.isHidden = true
//            headerView.oltOrder.isHidden = true
//            headerView.lblTotalAds.text = self.featureAddTitle
//            return headerView
//        case 1:
//            headerView.lblTotalAds.text = self.addcategoryTitle
//            headerView.oltOrder.setTitle(orderName, for: .normal)
//            headerView.btnSort = { () in
//                headerView.categoryID = self.categoryID
//                headerView.orderArray = self.orderArray
//                headerView.orderKeysArray = self.orderKeysArray
//                headerView.delegate = self
//                headerView.orderDropDown()
//                headerView.arrangeDropDown.show()
//            }
//            return headerView
//        default:
//            break
//        }
//        return UIView()
//    }
    
    //MARK:- API Call
    func categoryData(param: NSDictionary) {
        self.showLoader()
//        AddsHandler.categoryData(param: param, success: { (successResponse) in
//            self.stopAnimating()
//            if successResponse.success {
//                self.title = successResponse.extra.title
//                self.featureAddTitle = successResponse.data.featuredAds.text
//                self.addcategoryTitle = successResponse.topbar.countAds
//                self.currentPage = successResponse.pagination.currentPage
//                self.maximumPage = successResponse.pagination.maxNumPages
//
//                //set drop down data
//                self.orderName = successResponse.topbar.sortArrKey.value
//                self.orderArray = []
//                for order in successResponse.topbar.sortArr {
//                    self.orderKeysArray.append(order.key)
//                    self.orderArray.append(order.value)
//                }
//                AddsHandler.sharedInstance.objCategory = successResponse
//                AddsHandler.sharedInstance.isShowFeatureOnCategory = successResponse.extra.isShowFeatured
//                self.dataArray = successResponse.data.ads
//                self.categotyAdArray = successResponse.data.featuredAds.ads
//                self.tableView.reloadData()
//            } else {
//                let alert = Constants.showBasicAlert(message: successResponse.message)
//                self.presentVC(alert)
//            }
//        }) { (error) in
//            self.stopAnimating()
//            let alert = Constants.showBasicAlert(message: error.message)
//            self.presentVC(alert)
//        }
    }
    
    func loadMoreData(param: NSDictionary) {
        self.showLoader()
//        AddsHandler.categoryData(param: param, success: { (successResponse) in
//            self.stopAnimating()
//            if successResponse.success {
//                AddsHandler.sharedInstance.objCategory = successResponse
//                AddsHandler.sharedInstance.isShowFeatureOnCategory = successResponse.extra.isShowFeatured
//                self.dataArray.append(contentsOf: successResponse.data.ads)
//                //self.categotyAdArray.append(contentsOf: successResponse.data.featuredAds.ads)
//                self.tableView.reloadData()
//            } else {
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
