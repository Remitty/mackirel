//
//  DBFav.swift
//  Mackirel
//
//  Created by brian on 6/5/21.
//

import SQLite

class DBFav {
    private let db: Connection!
    
    private let tFavs = Table("User_Fav")
    
    private let productId = Expression<Int>("product_id")
    private let productImage = Expression<String>("product_image")
    
    init() {
        var applicationDocumentsDirectory: NSURL = {
        

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return urls[urls.count-1] as NSURL

        }()
        
        
        db = try! Connection("\(applicationDocumentsDirectory)db.sqlite3")
    }
    
    func onCreate() -> Bool {
        
        do {
            
            try db.run(tFavs.create { t in
                
                t.column(productId, unique: true)
                t.column(productImage)
                
            })
            return true
        } catch {
            print(" fav table create error")
            return false
        }
    }
    
     func insertFav(product: SimpleProductModel) -> Bool {
        do {
            let insert = tFavs.insert(
                productId <- product.id,
                productImage <- product.image
            )
            
            try db.run(insert)
            
            return true
        } catch  {
            return false
        }
    }
    
    func getUserFavIds() -> [Int] {
        var ids = [Int]()
        for fav in try! db.prepare(tFavs) {
            ids.append(fav[productId])
        }
        
        return ids
    }
    
    func getUserFavs() -> [FavModel] {
        var favs = [FavModel]()
        
        for item in try! db.prepare(tFavs) {
            let param = [
                "product_id": item[productId],
                "product_image": item[productImage],
                
            ] as [String : Any]
            let cart = FavModel(fromDictionary: param)
            favs.append(cart)
        }
        return favs
    }
    
    func deleteFav(id: Int) -> Bool {
        let fav = tFavs.filter(productId == id)
        do {
            try db.run(fav.delete())
        } catch  {
            return false
        }
        
        return true
    }
}
