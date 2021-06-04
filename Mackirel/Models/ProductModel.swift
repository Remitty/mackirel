//
//  ProductModel.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

struct ProductModel {
    
    var id : Int!
    
    var title : String!
    var description: String!
    var date : String!
    var location : String!
    var address: String!
    
    var images : [ProductImage]!
    var image: String!
    var isShipping : Bool!
    var price : Double!
    var shipPrice: Double!
    var qty: Int!
    var currency: Int!
    var lat: Double!
    var long: Double!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
//        date = dictionary["updated_at"] as? String
        location = dictionary["location"] as? String
        address = dictionary["address"] as? String
        
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
        
        if let priceTemp = (dictionary["shipping_price"] as? NSString)?.doubleValue {
            shipPrice = priceTemp
        } else {
            shipPrice =  dictionary["shipping_price"] as! Double
        }
        
        isShipping = (dictionary["isShipping"] as? Int) == 1 ? true : false
        qty = dictionary["qty"] as? Int
        currency = dictionary["currency"] as? Int
        
        if let temp = (dictionary["latitude"] as? NSString)?.doubleValue {
            lat = temp
        } else {
            lat =  dictionary["latitude"] as! Double
        }
        if let temp = (dictionary["longitude"] as? NSString)?.doubleValue {
            long = temp
        } else {
            long =  dictionary["longitude"] as! Double
        }
        
    }
    
    
}
