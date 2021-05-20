//
//  RequestHandler.swift
//  Mackirel
//
//  Created by brian on 5/19/21.
//

import Foundation
import Alamofire

class RequestHandler {
    static let sharedInstance = RequestHandler()
    
    class func loginUser(parameter: NSDictionary, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.login
        
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, isAuth: false, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            if let userData = dictionary["user"] as? [String:Any] {
                let accessToken = userData["access_token"] as! String
                UserDefaults.standard.set(accessToken, forKey: "access_token")
                let data = NSKeyedArchiver.archivedData(withRootObject: userData)
                UserDefaults.standard.set(data, forKey: "userAuthData")
                UserDefaults.standard.synchronize()
            }
            
            success(successResponse)
        }) { (error) in
                        
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func registerUser(parameter: NSDictionary, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError)-> Void) {
            let url = Constants.URL.register
            print(url)
            NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, isAuth:false, success: { (successResponse) in
                let dictionary = successResponse as! [String: Any]
                if let userData = dictionary["data"] as? [String:Any] {
                    let accessToken = userData["access_token"] as! String
                    UserDefaults.standard.set(accessToken, forKey: "access_token")
                    let data = NSKeyedArchiver.archivedData(withRootObject: userData)
                    UserDefaults.standard.set(data, forKey: "userAuthData")
                    UserDefaults.standard.synchronize()
                }
                success(successResponse)
            }) { (error) in
                            
                failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            }
        }
    
    class func profileUpdate(parameter: NSDictionary, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.UseProfileUpdate
        
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, isAuth:true, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            if let userData = dictionary["user"] as? [String:Any] {
                
                let data = NSKeyedArchiver.archivedData(withRootObject: userData)
                UserDefaults.standard.set(data, forKey: "userAuthData")
                UserDefaults.standard.synchronize()
            }
            
            success(successResponse)
        }) { (error) in
                        
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func getRequest(url: String, params: NSDictionary, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError) ->Void) {
          NetworkHandler.getRequest(url: url, parameters: params as? Parameters, isAuth:true, success: { (successResponse) in
              success(successResponse)
          }) { (error) in
                          
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
          }
   }
    
    class func postRequest(url: String, params: NSDictionary, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError) ->Void) {
          NetworkHandler.postRequest(url: url, parameters: params as? Parameters, isAuth:true, success: { (successResponse) in
              success(successResponse)
          }) { (error) in
                          
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
          }
   }
    
    class func deleteRequest(url: String, params: NSDictionary, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError) ->Void) {
          NetworkHandler.deleteRequest(url: url, parameters: params as? Parameters, isAuth:true, success: { (successResponse) in
              success(successResponse)
          }) { (error) in
                          
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
          }
   }
    
    class func getRequestWithoutAuth(url: String, params: NSDictionary, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError) ->Void) {
          NetworkHandler.getRequest(url: url, parameters: params as? Parameters, isAuth:false, success: { (successResponse) in
              success(successResponse)
          }) { (error) in
                          
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
          }
   }
}
