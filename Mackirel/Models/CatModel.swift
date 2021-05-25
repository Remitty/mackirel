//
//  CatModel.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

struct CatModel {
    
    var name: String!
    var img: String!
    var id: Int!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["cat_name"] as? String
        
        img = dictionary["cat_img"] as? String
        if !img.starts(with: "http") {
            img = Constants.URL.resource_url + img
        }
        id = dictionary["id"] as? Int
    }
}
