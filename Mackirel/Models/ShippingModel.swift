//
//  ShippingModel.swift
//  Mackirel
//
//  Created by brian on 6/7/21.
//

struct ShippingModel {
    var name: String!
    var address1: String!
    var address2: String!
    var country: String!
    var phone: String!
    var postalcode: String!
    var isDefault: Bool!
    
    init(fromDictionary dictionary: [String:Any]){
        isDefault = dictionary["hasDefault"] as? Bool
        
        if isDefault {
            self.address1 = dictionary["street"] as? String
            self.address2 = dictionary["apartment"] as? String
            self.country = dictionary["state_country"] as? String
            self.postalcode = dictionary["postal_code"] as? String
        } else {
            self.address1 = dictionary["address"] as? String
            self.address2 = dictionary["address2"] as? String
            self.country = dictionary["state"] as? String
            self.postalcode = dictionary["postalcode"] as? String
        }
        
        self.name = dictionary["contact_name"] as? String
        self.phone = dictionary["mobile"] as? String
    }
}
