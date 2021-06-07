//
//  AppDelegate.swift
//  Mackirel
//
//  Created by brian on 5/19/21.
//

import UIKit
import SlideMenuControllerSwift
import Firebase
import GooglePlaces
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey("AIzaSyAmYFlkNst4ayCNWR3cx2NwKqAPXV6Y-HQ")
        GMSServices.provideAPIKey("AIzaSyAmYFlkNst4ayCNWR3cx2NwKqAPXV6Y-HQ")
        
        
        
        DBCart().onCreate()
        DBFav().onCreate()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func moveToMain() {
        let mainVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let leftVC = storyboard.instantiateViewController(withIdentifier: "LeftVC") as! LeftVC
        let navi : UINavigationController = UINavigationController(rootViewController: mainVC)
        let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    func moveToLogin() {
        print("HERE")
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav: UINavigationController = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
}
