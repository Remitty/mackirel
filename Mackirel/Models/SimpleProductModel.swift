//
//  SimpleProductModel.swift
//  Mackirel
//
//  Created by brian on 6/10/21.
//

import Foundation

struct SimpleProductModel {
   
    var id: Int!
    var images : [ProductImage]!
    var image: String!
    var catId: Int!
    
    init(fromDictionary dictionary: [String: Any]) {
        id = dictionary["id"] as? Int
        
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
        
        guard let cat = dictionary["category"] as? [String: Any] else {
            return
        }
        catId = cat["id"] as? Int
    }
}
