//
//  FavModel.swift
//  Mackirel
//
//  Created by brian on 6/5/21.
//


struct FavModel {
    
    var id : Int!
    var image: String!
   
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["product_id"] as? Int
        image = dictionary["product_image"] as? String
        
    }
    
    
}

