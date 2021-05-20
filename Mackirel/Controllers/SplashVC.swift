//
//  SplashVC.swift
//  Mackirel
//
//  Created by brian on 5/19/21.
//
import Foundation
import UIKit
import NVActivityIndicatorView
import SlideMenuControllerSwift

class SplashVC: UIViewController, NVActivityIndicatorViewable {
    
    var window: UIWindow?
    
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.checkLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func checkLogin() {
        self.startAnimating()
        if defaults.bool(forKey: "isLogin") {
//            self.appDelegate.moveToMain()
            let data = defaults.object(forKey: "userAuthData")
            let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
            let userAuth = UserAuthModel(fromDictionary: objUser)
            guard let token = defaults.object(forKey: "access_token") as? String else {
                self.stopAnimating()
                self.moveToLogin()
                return
            }
            if userAuth.isCompleteProfile {
                self.stopAnimating()
                self.moveToMain()
            }
            else {
                self.stopAnimating()
                self.moveToCompleteProfile()
            }
        }
        else {
            self.stopAnimating()
            
//            self.appDelegate.moveToLogin()
            self.moveToLogin()
        }
    }
    
    func moveToMain() {
        self.stopAnimating()
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
         let leftVC = storyboard?.instantiateViewController(withIdentifier: "LeftVC") as! LeftVC
//         let navi : UINavigationController = UINavigationController(rootViewController: mainVC)
         let slideMenuController = SlideMenuController(mainViewController: mainVC, leftMenuViewController: leftVC)
        
        self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
        navigationController?.pushViewController(slideMenuController, animated: true)
    }
    
    func moveToLogin() {
        self.stopAnimating()

        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(loginVC, animated: true)
    }

    func moveToCompleteProfile() {
        self.stopAnimating()
//        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileEditController") as! ProfileEditController
//        navigationController?.pushViewController(profileVC, animated: true)
    }
}
