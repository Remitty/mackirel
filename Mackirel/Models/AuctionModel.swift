//
//  AuctionModel.swift
//  Mackirel
//
//  Created by brian on 6/10/21.
//

import Foundation

struct AuctionModel {
    var title : String!
    var description: String!
    var startPrice: String!
    var highPrice: String!
    var shippingPrice: String!
    var duration : Int!
    var date: String!
    var location : String!
    var address: String!
    var status: String!
    var payout: String!
    var winnerName: String!
    var winnerId: String!
    var biddersCnt: String!
    var id: String!
    var images : [ProductImage]!
    var image: String!
    var isShipping : Bool!
    var catId: String!
    var catName: String!
    
    
    init(fromDictionary dictionary: [String: Any]) {
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        date = dictionary["date"] as? String
        status = dictionary["status"] as? String
        isShipping = (dictionary["isShipping"] as? Int) == 1 ? true : false
        location = dictionary["location"] as? String
        if let priceTemp = (dictionary["start_price"] as? NSString)?.doubleValue {
            startPrice = PriceFormat.init(amount: priceTemp, currency: Currency.usd).description
        } else {
            startPrice = PriceFormat.init(amount: dictionary["start_price"] as! Double, currency: Currency.usd).description
        }
    
        if let priceTemp = (dictionary["high_price"] as? NSString)?.doubleValue {
            highPrice = PriceFormat.init(amount: priceTemp, currency: Currency.usd).description
        } else {
            highPrice = PriceFormat.init(amount: dictionary["high_price"] as! Double, currency: Currency.usd).description
        }
        
        if isShipping {
            if let priceTemp = (dictionary["shipping_price"] as? NSString)?.doubleValue {
                shippingPrice = PriceFormat.init(amount: priceTemp, currency: Currency.usd).description
            } else {
                shippingPrice = PriceFormat.init(amount: dictionary["shipping_price"] as! Double, currency: Currency.usd).description
            }
        }
        
        winnerId = dictionary["winner_id"] as? String
        biddersCnt = dictionary["bidder_count"] as? String
        id = "\(dictionary["id"]!)"
        
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
        
        let cat = dictionary["category"] as! [String: Any]
        catId = cat["id"] as? String
        catName = cat["cat_name"] as? String
        
        duration = dictionary["day_left"] as? Int

        
        guard let winner = dictionary["winner"] as? [String: Any] else {
            return
        }
        winnerName = "\(winner["first_name"]!) \(winner["last_name"]!)"
        
                
    }
    
    
}
