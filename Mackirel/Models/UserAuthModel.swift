//
//  UserAuthModel.swift
//  Mackirel
//
//  Created by brian on 5/19/21.
//

import Foundation
struct UserAuthModel {
    var first_name: String!
    var last_name: String!
    var email: String!
    var access_token: String!
    var isCompleteProfile: Bool!
    var id: String!
    var otp: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        first_name = dictionary["first_name"] as! String
        last_name = dictionary["last_name"] as! String
        email = dictionary["email"] as! String
        access_token = dictionary["access_token"] as? String
        isCompleteProfile = dictionary["isCompleteProfile"] as? Bool
        if let idTemp = dictionary["id"] {
            id = "\(dictionary["id"]!)"
        }

        if let otpTemp = dictionary["otp"] {
            otp = "\(dictionary["otp"]!)"
        }
        
    }
}
