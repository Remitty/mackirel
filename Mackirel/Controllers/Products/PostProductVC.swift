//
//  PostProduct.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
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


class PostProductVC: UITableViewController, GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate , UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, NVActivityIndicatorViewable {
  
  
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
    
    @IBOutlet weak var txtAddress: UITextField! {
        didSet{
            txtAddress.delegate = self
        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var deliveryOptionView: UIView!
    
    @IBOutlet weak var txtShippingPrice: UITextField! {
        didSet {
            txtShippingPrice.delegate = self
        }
    }
    
    @IBOutlet weak var featureOptionView: UIView!
    
    
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
    
    let map = GMSMapView()
    let locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 25.276987, longitude: 55.296249)
    
    var latitude = ""
    var longitude = ""
   // var objFieldData = [AdPostField]()
    var valueArray = [String]()
    
    var localVariable = ""
    
    //this array get data from previous controller
    var objArray = [ProductModel]()
    
    
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
    var featureRadioGroup: RadioGroup!
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        
        if latitude != "" && longitude != "" {
            initialLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        }
        self.centerMapOnLocation(location: initialLocation)
        self.addAnnotations(coords: [initialLocation])
        self.locationPopup()
        
        initDeliveryView()
        initFeatureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Text Field Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = GMSAutocompleteViewController()
        searchVC.delegate = self
        self.presentVC(searchVC)
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
    
    func initFeatureView() {
        
        self.featureRadioGroup = RadioGroup(titles: ["$0.88/1day", "$2.5/3days", "$5/1week"])
        self.featureRadioGroup .isVertical = false
        self.featureRadioGroup .selectedIndex = 0
        
        self.featureOptionView.addSubview(self.featureRadioGroup)
        self.featureRadioGroup .translatesAutoresizingMaskIntoConstraints = false
        self.featureRadioGroup .centerXAnchor.constraint(equalTo: self.featureOptionView.centerXAnchor).isActive = true
        self.featureRadioGroup .centerYAnchor.constraint(equalTo: self.featureOptionView.centerYAnchor).isActive = true
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
   
    // Google Places Delegate Methods
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place Name : \(place.name)")
        print("Place Address : \(place.formattedAddress ?? "null")")
        txtAddress.text = place.formattedAddress
        self.address = place.formattedAddress!
        
        self.latitude = String(place.coordinate.latitude)
        self.longitude = String(place.coordinate.longitude)
        self.dismissVC(completion: nil)
        
        if latitude != "" && longitude != "" {
            initialLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        }
        self.centerMapOnLocation(location: initialLocation)
        self.addAnnotations(coords: [initialLocation])
        self.setupView()
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismissVC(completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismissVC(completion: nil)
    }
    
    //MARK:- Map View Delegate Methods
    
    func setupView (){
        mapView.delegate = self
        mapView.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Map
    func centerMapOnLocation (location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func addAnnotations(coords: [CLLocation]){
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            mapView.addAnnotation(anno);
        }
    }
    
    private func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else {
            let pinIdent = "Pin"
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
            }
            return pinView;
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.latitude = String(location.coordinate.latitude)
        self.longitude = String(location.coordinate.longitude)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    //MARK:- IBActions
    
    @IBAction func actionPopup(_ sender: Any) {
        locationDropDown.show()
    }
    
    @IBAction func actionPostAdd(_ sender: Any) {
        if address.isEmpty{
            
            self.txtAddress.shake(6, withDelta: 10, speed: 0.06)
            return
        }
        
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
//            "location":  location,
            "address":  address,
            "location_lat": latitude,
            "location_long": longitude,
            "featured": self.featureRadioGroup.selectedIndex,
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
        RequestHandler.postRequest(url: Constants.URL.POST_NEW_PRODUCT ,params: param, success: { (successResponse) in
            self.stopAnimating()
            self.imageIdArray.removeAll()
            
        }) { (error) in
            self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
}
