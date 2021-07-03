//
//  PostAuctionVC.swift
//  Mackirel
//
//  Created by brian on 6/11/21.
//

import UIKit
import MapKit
import DropDown
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import NVActivityIndicatorView
import JGProgressHUD
import RadioGroup


class PostAuctionVC: UITableViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
  
  
    @IBOutlet weak var txtName: UITextField! {
        didSet {
            txtName.delegate = self
        }
    }
    @IBOutlet weak var txtDescription: UITextField! {
        didSet {
            txtDescription.delegate = self
        }
    }
    @IBOutlet weak var txtPrice: UITextField! {
        didSet {
            txtPrice.delegate = self
        }
    }
    @IBOutlet weak var txtCount: UITextField! {
        didSet {
            txtCount.delegate = self
        }
    }
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var oltPopup: UIButton! {
        didSet {
            oltPopup.contentHorizontalAlignment = .left
        }
    }
    
    
    @IBOutlet weak var deliveryOptionView: UIView!
    
    @IBOutlet weak var txtShippingPrice: UITextField! {
        didSet {
            txtShippingPrice.delegate = self
        }
    }
    

    //MARK:- Properties
    let locationDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.locationDropDown
        ]
    }()
    
    var adId = -1
    var popUpArray = [String]()
    var hasSubArray = [Bool]()
    var locationIdArray = [String]()
    
    var hasSub = false
    var selectedID = ""
    
    var popUpTitle = ""
    var popUpConfirm = ""
    var popUpCancel = ""
    var popUpText = ""
    
   
   // var objFieldData = [AdPostField]()
    var valueArray = [String]()
    
    var localVariable = ""
    
    //this array get data from previous controller
    var objArray = [AuctionModel]()
    
    
    var imageIdArray = [Int]()
    var descriptionText = ""
    
    var imageArray = [ProductImage]()
    // get values in populate data and send it with parameters
    
    var address = ""
    
    var isFeature = "false"
    var isBump = false
    var localDictionary = [String: Any]()
    var selectedCountry = ""
    
    var deliveryRadioGroup: RadioGroup!
    
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        
        
        initDeliveryView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initDeliveryView() {
        txtShippingPrice.isHidden = true
        
        
        self.deliveryRadioGroup = RadioGroup(titles: ["Local PickUp", "Shipping"])
        self.deliveryRadioGroup .isVertical = false
        self.deliveryRadioGroup .selectedIndex = 0
        self.deliveryRadioGroup .addTarget(self, action: #selector(deliveryOptionSelected), for: .valueChanged)
        self.deliveryOptionView.addSubview(self.deliveryRadioGroup)
        self.deliveryRadioGroup .translatesAutoresizingMaskIntoConstraints = false
        self.deliveryRadioGroup .centerXAnchor.constraint(equalTo: self.deliveryOptionView.centerXAnchor).isActive = true
        self.deliveryRadioGroup .centerYAnchor.constraint(equalTo: self.deliveryOptionView.centerYAnchor).isActive = true
    }
    
    
    @objc func deliveryOptionSelected() {
        print(self.deliveryRadioGroup .selectedIndex)
        switch self.deliveryRadioGroup .selectedIndex {
        case 0:
            self.txtShippingPrice.isHidden = true
            break
        case 1:
            self.txtShippingPrice.isHidden = false
            break
        default:
            self.txtShippingPrice.isHidden = true
        }
    }
    
   
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    

    
    
    //MARK:- SetUp Drop Down
    func locationPopup() {
        locationDropDown.anchorView = oltPopup
        locationDropDown.dataSource = popUpArray
        locationDropDown.selectionAction = { [unowned self]
            (index, item) in
            self.oltPopup.setTitle(item, for: .normal)
            self.selectedCountry = item
            self.hasSub = self.hasSubArray[index]
            self.selectedID = self.locationIdArray[index]
            print(self.selectedID)
            
            if self.hasSub {
                let param: [String: Any] = ["ad_country" : self.selectedID]
                print(param)
//                self.subLocations(param: param as NSDictionary)
            }
        }
    }
    
    //MARK:- Sub Locations Delegate Method

    func subCategoryDetails(name: String, id: Int, hasSubType: Bool, hasTempelate: Bool, hasCatTempelate: Bool) {
      
        if hasSubType {
            let param: [String: Any] = ["ad_country" : id]
            print(param)
//            self.subLocations(param: param as NSDictionary)
            self.selectedID = String(id)
        }
        else {
            self.oltPopup.setTitle(name, for: .normal)
            self.selectedID = String(id)
        }
    }
   
    
    @IBAction func actionPostAdd(_ sender: Any) {
        
        
        guard let title = txtName.text else {
            return
        }
        
        if title.isEmpty {
            
            self.txtName.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        guard let description = txtDescription.text else {
            return
        }
        
        if description.isEmpty {
            
            self.txtDescription.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        guard let price = txtPrice.text else {
            return
        }
        
        if price.isEmpty || price.starts(with: ".") {
            
            self.txtPrice.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        guard let count = txtCount.text else {
            return
        }
        
        if count.isEmpty || count.starts(with: ".") {
            
            self.txtCount.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
        if self.deliveryRadioGroup.selectedIndex == 1 {
            guard let shippingPrice = txtShippingPrice.text else {
                return
            }
            
            if shippingPrice.isEmpty || shippingPrice.starts(with: ".") {
                
                self.txtShippingPrice.shake(6, withDelta: 10, speed: 0.06)
                return
            }
        }
        
        let parameter: [String: Any] = [
            "title": title,
            "description": description,
            "count": count,
            "price": price,
            "cat_id": 1,
            "currency": 1,
            "images": imageIdArray,
            
            "isShipping": self.deliveryRadioGroup.selectedIndex,
            "shipping_price": self.txtShippingPrice.text!,
            "ad_id": self.adId,
            
        ]
  
        self.postAd(param: parameter as NSDictionary)
        
    }
    
    //MARK:- API Call
    //Post Add
    func postAd(param: NSDictionary) {
        self.showLoader()
        RequestHandler.postRequest(url: Constants.URL.CREATE_AUCTION ,params: param, success: { (successResponse) in
            self.stopAnimating()
            self.imageIdArray.removeAll()
            
        }) { (error) in
            self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
}
