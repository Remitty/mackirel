//
//  ShippingAddressVC.swift
//  Mackirel
//
//  Created by brian on 6/7/21.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class ShippingaddressVC: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtApt: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostalcode: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnSet: UIButton!
    
    var shippingAddress: ShippingModel!
    var hasDefault = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func actionSetDefault(_ sender: Any) {
        
    }
    
    @IBAction func actionSaveShippingAddress(_ sender: Any) {
        
    }
    
    func getData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        RequestHandler.getRequest(url: Constants.URL.GET_SHIPPING_ADDRESS, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            let address = dictionary["address"] as! [String: Any]
            
            self.shippingAddress = ShippingModel(fromDictionary: address)
            
            self.txtName.text = self.shippingAddress.name
            self.txtPhone.text = self.shippingAddress.phone
            self.txtAddress.text = self.shippingAddress.address1
            self.txtApt.text = self.shippingAddress.address2
            self.txtCountry.text = self.shippingAddress.country
            self.txtPostalcode.text = self.shippingAddress.postalcode
            
                    
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
    }
    
    
    
}
