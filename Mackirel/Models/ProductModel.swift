//
//  ProductModel.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

struct ProductModel {
    
    var id : Int!
    var type : String!
    var path : String!
    var date : String!
    var location : String!
    var title : String!
    var images : [ProductImage]!
    var image: String!
    var isFav : Bool!
    var price : Double!
    var qty: Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        type = dictionary["type"] as? String
        path = dictionary["path"] as? String
        date = dictionary["updated_at"] as? String
        location = dictionary["location"] as? String
        title = dictionary["title"] as? String
        if let imagesTemp = dictionary["images"] as? [[String: Any]] {
            
            var imageTemp: ProductImage!
            images = [ProductImage]()
            for item in imagesTemp {
                imageTemp = ProductImage(fromDictionary: item)
                images.append(imageTemp)
            }
            if images.count > 0 {
                
                image = images[0].thumb
                if !image.starts(with: "http") {
                    image = Constants.URL.resource_url + image
                }
            }
        }
        
        if let priceTemp = (dictionary["unit_price"] as? NSString)?.doubleValue {
            price = priceTemp
        } else {
            price =  dictionary["unit_price"] as! Double
        }
        
        qty = dictionary["qty"] as? Int
        isFav = dictionary["isFav"] as? Bool
    }
    
    
}
