//
//  AuctionVC.swift
//  Mackirel
//
//  Created by brian on 6/10/21.
//


import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView
import UserNotifications
//import IQKeyboardManagerSwift

class AuctionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable{
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .none
            
            
        }
    }
    
    
    @IBOutlet weak var catsView: CatsTableCell!
    
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    var categoryArray = [CatModel]()
    var auctionArray = [SimpleProductModel]()
    var auctionArrayTemp = [SimpleProductModel]()
 
    var catId: Int = -1
    //var homeTitle = ""
    var numberOfColumns:CGFloat = 0
    
    var heightConstraintTitleLatestad = 0
    var heightConstraintTitlead = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        catsView.delegate = self
        
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Auction Controller")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = false
        
        self.loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell: ProductsTableCell  = tableView.dequeueReusableCell(withIdentifier: "ProductsTableCell", for: indexPath) as! ProductsTableCell

        cell.delegate = self
        cell.dataArray = self.auctionArray
        
        cell.isHideFav = true
        
        cell.collectionView.reloadData()
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        
        var height: CGFloat = 0
        if auctionArray.count > 0 {
            height = CGFloat(590 + heightConstraintTitleLatestad)
            self.lbEmpty.isHidden = true
        }
        else {
            self.lbEmpty.isHidden = false
        }
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //MARK:- API Call
    
    //get home data
    func loadData() {
//         self.navigationController?.isNavigationBarHidden = false
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getRequestWithoutAuth(url: Constants.URL.AUCTION_LIST, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var cat: CatModel!
            
            if let cats = dictionary["cats"] as? [[String: Any]] {
                self.categoryArray = [CatModel]()
                for item in cats {
                    cat = CatModel(fromDictionary: item)
                    self.categoryArray.append(cat)
                    
                }
                self.catsView.numberOfColums = CGFloat(self.categoryArray.count)
                self.catsView.categoryArray = self.categoryArray
                self.catsView.collectionView.reloadData()
            }
            
            var product: SimpleProductModel!
            
            if let temp = dictionary["data"] as? [[String: Any]] {
                self.auctionArray = [SimpleProductModel]()
                for item in temp {
                    product = SimpleProductModel(fromDictionary: item)
                    self.auctionArray.append(product)
                    self.auctionArrayTemp.append(product)
                }
                if self.auctionArray.count > 0 {
//                    self.isShowLatest = true
                }
            }
            self.tableView.reloadData()
                    
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
   
    }

extension AuctionVC: ProductsTableCellDelegate {
    func loadMore(step: Int) {
//        self.pageNumber = step
//        searchProducts()
    }
    //MARK:- go to add detail controller
    func goToProductDetail(id: Int) {
        print("detail\(id)")
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AuctionDetailVC") as! AuctionDetailVC
        addDetailVC.ad_id = id
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    
}

extension AuctionVC: CategoryDetailDelegate {
    
    //MARK:- go to category detail
    func goToCategoryDetail(id: Int) {
        print("gere\(id)")
        self.catId = id
        self.auctionArray.removeAll()
        for item in self.auctionArrayTemp {
            if item.catId == id {
                self.auctionArray.append(item)
            }
        }
        tableView.reloadData()
        
    }
}

