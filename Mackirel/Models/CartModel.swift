//
//  CartModel.swift
//  Mackirel
//
//  Created by brian on 6/4/21.
//

struct CartModel {
    
    var id : Int!
    var title : String!
//    var type: String!
    var image: String!
    var price : Double!
    var totalPrice: Double!
    var qty: Int!
    var cartQty: Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["product_id"] as? Int
        title = dictionary["product_name"] as? String
//        type = dictionary["product_type"] as? String
        image = dictionary["product_image"] as? String
        price =  dictionary["product_price"] as? Double
        qty = dictionary["product_qty"] as? Int
        cartQty = dictionary["product_cart_qty"] as? Int
        totalPrice = dictionary["product_total_price"] as? Double
    }
    
    
}
