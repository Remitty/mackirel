//
//  ProductImage.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

struct ProductImage {
    
    var full : String!
    var imgId : Int!
    var thumb : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        full = dictionary["full"] as? String
        imgId = dictionary["img_id"] as? Int
        thumb = dictionary["thumb"] as? String
        if !thumb.starts(with: "http") {
            thumb = Constants.URL.resource_url + thumb
        }
    }
    
}
