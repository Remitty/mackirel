//
//  UserModel.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

struct UserModel {
    var id: String!
    var first_name: String!
    var last_name: String!
    var phone: String!
    var email: String!
    var dob: String!
    var address: String!
    var address2: String!
    var city: String!
    var country: String!
    var national: String!
    var postal_code: String!
    var profile: UserProfileModel!
    
    init(fromDictionary dictionary: [String: Any]) {
        id = dictionary["id"] as? String
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        phone = dictionary["mobile"] as? String
        email = dictionary["email"] as? String
        guard let profiledata = dictionary["profile"] as? [String : Any] else {
            return
        }
        
        profile = UserProfileModel.init(fromDictionary:profiledata)
        dob = profile.dob
        address = profile.address
        address2 = profile.address2
        city = profile.city
        country = profile.country
        national = profile.national
        postal_code = profile.postal_code
        
        
        
        
    }
    
    
}
