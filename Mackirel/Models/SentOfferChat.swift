//
//  SentOfferChat.swift
//  Mackirel
//
//  Created by brian on 6/10/21.
//

struct SentOfferChat{
    
    var channel : String!
    var date : String!
    var id : String!
    var img : String!
    var text : String!
    var type : String!
    var isMine: Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        channel = dictionary["channel"] as? String
        date = dictionary["date"] as? String
        id = dictionary["id"] as? String
        img = dictionary["img"] as? String
        text = dictionary["text"] as? String
        type = dictionary["type"] as? String
    }
    
}
