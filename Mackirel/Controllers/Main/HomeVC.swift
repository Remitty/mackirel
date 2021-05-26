//
//  HomeVC.swift
//  Mackirel
//
//  Created by brian on 5/19/21.

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView
import UserNotifications
import IQKeyboardManagerSwift

var currentVc: UIViewController!

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, ProductDetailDelegate, CategoryDetailDelegate, UISearchBarDelegate, UNUserNotificationCenterDelegate, NearBySearchDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "SearchSectionCell", bundle: nil), forCellReuseIdentifier: "SearchSectionCell")
            
        }
    }
    
    let keyboardManager = IQKeyboardManager.shared
    
    //MARK:- Properties
    
    var defaults = UserDefaults.standard
    
    var categoryArray = [CatModel]()
    var featuredArray = [ProductModel]()
    var latestArray = [ProductModel]()
    var catLocationsArray = [CatModel]()
    var nearByAddsArray = [ProductModel]()
    
    var isShowLatest = false
    var isShowNearby = false
    var isShowFeature = false
    var isShowLocationButton = false
    var isShowCategoryButton = false
    
    var featurePosition = ""
    var animalSectionTitle = ""
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    var addPosition = ["search_Cell"]
    var barButtonItems = [UIBarButtonItem]()
    
    
    var viewAllText = ""
    var catLocationTitle = ""
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    //var homeTitle = ""
    var numberOfColumns:CGFloat = 0
    
    var heightConstraintTitleLatestad = 0
    var heightConstraintTitlead = 0
    
    
    
    
    //MARK:- View Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.isNavigationBarHidden = false
        
        
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Home Controller")
        

        self.showLoader()
        self.homeData()
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.navigationButtons()
        //UserDefaults.standard.setValue("1", forKey: "langFirst")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
//            self.oltAddPost.isHidden = false
//        }
//          currentVc = self
    }
    
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- go to add detail controller
    func goToProductDetail(id: Int) {
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        addDetailVC.ad_id = id
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    //MARK:- go to category detail
    func goToCategoryDetail(id: Int) {
//        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
//        categoryVC.categoryID = id
//        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- Go to Location detail
    func goToCLocationDetail(id: Int) {
//        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
//        categoryVC.categoryID = id
//        categoryVC.isFromLocation = true
//        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- Near by search Delaget method
    func nearbySearchParams(lat: Double, long: Double, searchDistance: CGFloat, isSearch: Bool) {
        self.latitude = lat
        self.longitude = long
        self.searchDistance = searchDistance
        if isSearch {
            let param: [String: Any] = ["nearby_latitude": lat, "nearby_longitude": long, "nearby_distance": searchDistance]
            print(param)
            self.nearBySearch(param: param as NSDictionary)
        } else {
            let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
            print(param)
            self.nearBySearch(param: param as NSDictionary)
        }
    }
    
    
    func navigationButtons() {
        //Location Search
        let locationButton = UIButton(type: .custom)
        if #available(iOS 11, *) {
            locationButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
            locationButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            locationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        locationButton.setBackgroundImage(image, for: .normal)
        locationButton.tintColor = UIColor.white
        locationButton.addTarget(self, action: #selector(onClicklocationButton), for: .touchUpInside)
        let barButtonLocation = UIBarButtonItem(customView: locationButton)
        if defaults.bool(forKey: "showNearBy") {
            self.barButtonItems.append(barButtonLocation)
        }
        //Search Button
        let searchButton = UIButton(type: .custom)
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        if #available(iOS 11, *) {
            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        searchButton.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: searchButton)
        if defaults.bool(forKey: "showNearBy") {
            barButtonItems.append(searchItem)
        }
        self.barButtonItems.append(searchItem)
        self.navigationItem.rightBarButtonItems = barButtonItems
    }
    
    @objc func onClicklocationButton() {
        let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearch") as! LocationSearch
        locationVC.delegate = self
        view.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = .identity
        }) { (success) in
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }
    
    //MARK:- Search Controller
    @objc func actionSearch(_ sender: Any) {
        keyboardManager.enable = true
        if isNavSearchBarShowing {
            self.searchBarNavigation.text = ""
            self.backgroundView.removeFromSuperview()
            self.addTitleView()
        } else {
            self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.backgroundView.isOpaque = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.delegate = self
            self.backgroundView.addGestureRecognizer(tap)
            self.backgroundView.isUserInteractionEnabled = true
            self.view.addSubview(self.backgroundView)
            self.adNavSearchBar()
        }
    }
    
    @objc func handleTap(_ gestureRocognizer: UITapGestureRecognizer) {
        self.actionSearch("")
    }
    
    func adNavSearchBar() {
        searchBarNavigation.placeholder = "Search Ads"
        searchBarNavigation.barStyle = .default
        searchBarNavigation.isTranslucent = false
        searchBarNavigation.barTintColor = UIColor.groupTableViewBackground
        searchBarNavigation.backgroundImage = UIImage()
        searchBarNavigation.sizeToFit()
        searchBarNavigation.delegate = self
        self.isNavSearchBarShowing = true
        searchBarNavigation.isHidden = false
        //searchBarNavigation.ti
        navigationItem.titleView = searchBarNavigation
        searchBarNavigation.becomeFirstResponder()
    }
    
    func addTitleView() {
        self.searchBarNavigation.endEditing(true)
        self.isNavSearchBarShowing = false
        self.searchBarNavigation.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
    //MARK:- Search Bar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.searchBarNavigation.endEditing(true)
        searchBar.endEditing(true)
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.searchBarNavigation.endEditing(true)
        guard let searchText = searchBar.text else {return}
        if searchText == "" {
            
        } else {
            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            categoryVC.searchText = searchText
            categoryVC.isFromTextSearch = true
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
    //MARK:- Table View Delegate Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        
            // Else Condition of Second Type
        
        if section == 0 { // search section
            value = 1
        }
        else if section == 1 { // category
           value = 1
       }
        else if section == 2 { // feature
            if isShowFeature {
                value = 1
            } else {
                value = 0
            }
        }else if section == 3 { // latest
            value = 1
        }
        
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
 
            switch section {
            case 0:
                let cell: SearchSectionCell = tableView.dequeueReusableCell(withIdentifier: "SearchSectionCell", for: indexPath) as! SearchSectionCell
                
                return cell
            
            case 1:
                let cell: CatsTableCell = tableView.dequeueReusableCell(withIdentifier: "CatsTableCell", for: indexPath) as! CatsTableCell
                
                cell.numberOfColums = self.numberOfColumns
                
                cell.categoryArray  = self.categoryArray
                cell.delegate = self
                cell.collectionView.reloadData()
                return cell
            case 2:
                if isShowFeature {
                    let cell: FeaturedProductTableCell = tableView.dequeueReusableCell(withIdentifier: "FeaturedProductTableCell", for: indexPath) as! FeaturedProductTableCell

                    cell.dataArray = featuredArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                }
            case 3:
                if isShowLatest {
                    let cell: ProductsTableCell  = tableView.dequeueReusableCell(withIdentifier: "ProductsTableCell", for: indexPath) as! ProductsTableCell

                    cell.delegate = self
                    cell.dataArray = self.latestArray
//                    heightConstraintTitleLatestad = Int(cell.heightConstraintTitle.constant)
                    cell.collectionView.reloadData()
                    return cell
                }
            
            
            default:
                break
            }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var totalHeight : CGFloat = 0
        var height: CGFloat = 0
        
           
            if section == 0 {
                height = 65
            }
            else if section == 1 {
                height = 100
            }
             else if section == 2 {
                if self.isShowFeature {
                    if featuredArray.isEmpty {
                        height = 0
                    } else {
                        height = 230
                    }
                } else {
                    height = 0
                }
            } else if section ==  3 {
                if self.isShowLatest {
                    height = CGFloat(590 + heightConstraintTitleLatestad)
                } else {
                    height = 0
                }
            } else {
                height = 0
            }
       
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    //MARK:- API Call
    
    //get home data
    func homeData() {
//         self.navigationController?.isNavigationBarHidden = false
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getRequestWithoutAuth(url: Constants.URL.GET_HOME_DATA, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let data = dictionary["data"] as! [String: Any]
                    
            var cat: CatModel!
            
            if let cats = data["cat_icons"] as? [[String: Any]] {
                self.categoryArray = [CatModel]()
                for item in cats {
                    cat = CatModel(fromDictionary: item)
                    self.categoryArray.append(cat)
                }
                self.numberOfColumns = CGFloat(self.categoryArray.count)
            }
            
            var product: ProductModel!
            let featured = data["featured"] as! [String: Any]
            let latest = data["latest_ads"] as! [String: Any]
            if let temp = featured["products"] as? [[String: Any]] {
                self.featuredArray = [ProductModel]()
                for item in temp {
                    product = ProductModel(fromDictionary: item)
                    self.featuredArray.append(product)
                }
                if self.featuredArray.count > 0 {
                    self.isShowFeature = true
                }
            }
            if let temp = latest["products"] as? [[String: Any]] {
                self.latestArray = [ProductModel]()
                for item in temp {
                    product = ProductModel(fromDictionary: item)
                    self.latestArray.append(product)
                }
                if self.latestArray.count > 0 {
                    self.isShowLatest = true
                }
            }
            self.tableView.reloadData()
                    
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
   
    //MARK:- Send fcm token to server
    func sendFCMToken() {
//        var fcmToken = ""
//        if let token = defaults.value(forKey: "fcmToken") as? String {
//            fcmToken = token
//        } else {
//            fcmToken = appDelegate.deviceFcmToken
//        }
//        let param: [String: Any] = ["firebase_id": fcmToken]
//        print(param)
//        AddsHandler.sendFirebaseToken(parameter: param as NSDictionary, success: { (successResponse) in
//            self.stopAnimating()
//            print(successResponse)
//        }) { (error) in
//            self.stopAnimating()
//            let alert = Constants.showBasicAlert(message: error.message)
//            self.presentVC(alert)
//        }
    }
    
    //MARK:- Near By Search
    func nearBySearch(param: NSDictionary) {
        self.showLoader()
//        AddsHandler.nearbyAddsSearch(params: param, success: { (successResponse) in
//            self.stopAnimating()
//            if successResponse.success {
//                let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//                categoryVC.latitude = self.latitude
//                categoryVC.longitude = self.longitude
//                categoryVC.nearByDistance = self.searchDistance
//                categoryVC.isFromNearBySearch = true
//                self.navigationController?.pushViewController(categoryVC, animated: true)
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
