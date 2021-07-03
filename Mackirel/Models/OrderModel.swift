//
//  OrderModel.swift
//  Mackirel
//
//  Created by brian on 6/16/21.
//

import Foundation
struct OrderModel {
    var orderId: String!
    var productCnt: String!
    var kind: String!
    var totalPrice: String!
    var status: String!
    var shipping: Int!
    var date: String!
    var contactName: String!
    var street: String!
    var apart: String!
    var state: String!
    var postal: String!
    var mobile: String!
    var orderProducts: [OrderProductModel]!
    
    init(fromDictionary dictionary: [String: Any]) {
        orderId = dictionary["order_id"] as? String
        productCnt = dictionary["no_products"] as? String
        kind = dictionary["kind"] as? String
        let taxes: Double = dictionary["taxes"] as! Double
    }
}
