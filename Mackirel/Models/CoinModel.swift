//
//  CoinModel.swift
//  Mackirel
//
//  Created by brian on 7/3/21.
//

import Foundation

struct CoinModel {
    var symbol: String!
    var name: String!
    var icon: String!
    var id: Int!
    var price: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["coin_name"] as? String
        symbol = dictionary["coin_symbol"] as? String
        icon = dictionary["icon"] as? String
        if !icon.starts(with: "http") {
            icon = Constants.URL.resource_url + icon
        }
        id = dictionary["id"] as? Int
        price = PriceFormat(amount: dictionary["coin_rate"] as! Double, currency: .usd).description
    }
}
