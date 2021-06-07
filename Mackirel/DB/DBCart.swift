//
//  DBHandler.swift
//  Mackirel
//
//  Created by brian on 6/4/21.
//  Copyright © 2021 apple. All rights reserved.
//

import SQLite

class DBCart {
    let db: Connection!
    
    let tCarts = Table("User_Carts")
    let tCartIds = Table("Cart_Product_Ids")
    
    let cartId = Expression<Int64>("cart_id")
    let productId = Expression<Int>("product_id")
    let productName = Expression<String?>("product_name")
    let productImage = Expression<String?>("product_image")
//    let productType = Expression<String?>("product_type")
    let productQty = Expression<Int>("product_qty")
    let productCartQty = Expression<Int>("product_cart_qty")
    let productPrice = Expression<Double>("product_price")
    let productTotalPrice = Expression<Double>("product_total_price")
    
    init() {
        var applicationDocumentsDirectory: NSURL = {
        

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return urls[urls.count-1] as NSURL

        }()
        
//        print(applicationDocumentsDirectory)
        db = try! Connection("\(applicationDocumentsDirectory)db.sqlite3")
    }
    
    
    func onCreate() ->Bool {
        
        do {
            
            try db.run(tCarts.create { t in
//                t.column(cartId, primaryKey: true)
                t.column(productId, unique: true)
                t.column(productName)
                t.column(productImage)
                
                t.column(productQty)
                t.column(productCartQty)
                t.column(productPrice)
                t.column(productTotalPrice)
                
            })
            
        } catch {
            print(" cart table create error")
            return false
        }
        
        do {
            try db.run(tCartIds.create{ t in
                t.column(productId, unique: true)
                t.column(productCartQty)
            })
        } catch {
            print(" cartids table create error")
            return false
        }
        
        return true
    }
    
    func addCartItem(product: ProductModel) -> Bool {
        do {
            let insert = tCarts.insert(
                productId <- product.id,
                productName <- product.title,
                productImage <- product.image,
                productQty <- product.qty,
                productCartQty <- 1,
                productPrice <- product.price,
                productTotalPrice <- product.price
                
            )
            
            try db.run(insert)
            
            let cartiteminsert = tCartIds.insert(
                productId <- product.id,
                productCartQty <- 1
            )
            
            try db.run(cartiteminsert)
        } catch  {
            print("add cart error")
            return false
        }
        
        return true
        
    }
    
    func getCartItems() -> [CartModel] {
        var carts = [CartModel]()
        
        for item in try! db.prepare(tCarts) {
            let param = [
                "product_id": item[productId],
                "product_name": item[productName]!,
                "product_image": item[productImage]!,
//                "product_type": item[productType]!,
                "product_qty": item[productQty],
                "product_cart_qty": item[productCartQty],
                "product_price": item[productPrice],
                "product_total_price": item[productTotalPrice]
            ] as [String : Any]
            let cart = CartModel(fromDictionary: param)
            carts.append(cart)
        }
        return carts
    }
    
    func getCartProducts() -> [[String: Any]] {
        var params = [[String: Any]]()
        for item in try! db.prepare(tCartIds) {
            let param = [
                "id": item[productId],
                "qty": item[productCartQty]
            ] as [String : Any]
            params.append(param)
        }
        
        return params
    }
    
    func getCartIds() -> [Int] {
        var ids = [Int]()
        for cart in try! db.prepare(tCartIds) {
            ids.append(cart[productId])
        }
        
        return ids
    }
    
    func getCartQty(id: Int) -> Int {
        var qty = 0
        do {
            for row in try db.prepare("SELECT product_cart_qty FROM Cart_Product_Ids where product_id = \(id)") {
                qty = row[0] as! Int
            }
        } catch {
            qty = -1
        }
        
        return qty
    }
    
    func updateCartItem(id: Int, qty: Int) -> Bool {
        let cart = tCartIds.filter(productId == id)
        do {
            try db.run(cart.update(productCartQty <- qty))
        } catch {
            return false
        }
        
        return true
        
    }
    
    func deleteCartItem(id: Int) -> Bool {
        let cart = tCarts.filter(productId == id)
        do {
            try db.run(cart.delete())
        } catch  {
            return false
        }
        
        return true
    }
    
    func deleteCartItemID(id: Int) -> Bool {
        let cart = tCartIds.filter(productId == id)
        do {
            try db.run(cart.delete())
        } catch  {
            return false
        }
        
        return true
    }
    
    
    func clearCart() -> Bool {
        do {
            try db.run(tCartIds.delete())
            try db.run(tCarts.delete())
            return true
        } catch {
            return false
        }
        
    }

}
