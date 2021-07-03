//
//  OrderProductModel.swift
//  Mackirel
//
//  Created by brian on 6/16/21.
//

import Foundation
struct OrderProductModel {
    
    var productCnt: String!
    var product: ProductModel!
    
    init(fromDictionary dictionary: [String: Any]) {
        productCnt = dictionary["count"] as? String
        product = ProductModel(fromDictionary: dictionary["product"] as! [String: Any]) 
    }
}
