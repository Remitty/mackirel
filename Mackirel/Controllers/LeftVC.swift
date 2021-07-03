//
//  LeftVC.swift
//  Mackirel
//
//  Created by brian on 5/19/21.
//

import Foundation
import SlideMenuControllerSwift
import NVActivityIndicatorView

enum MainMenu: Int {
    
    case auction = 0
    case payment
    case withdraw
    case cryptos
    case myorders
    case mylists
    case myauctions
    case message
    case support
    case logout
}

enum OtherMenues: Int {
    case support
    case logout
}

protocol changeOtherMenuesProtocol {
    func changeMenu(_ other: MainMenu )
}

class LeftVC: UIViewController, UITableViewDelegate, UITableViewDataSource, changeOtherMenuesProtocol {

    //MARK:- Outlets
    @IBOutlet weak var imgProfilePicture: UIImageView! {
        didSet {
//            imgProfilePicture.round()
        }
    }
    
    @IBOutlet weak var containerViewImage: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorColor = UIColor.darkGray
            tableView.separatorStyle = .singleLineEtched
        }
    }
    
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbUserEmail: UILabel!
    
    
    //MARK:- Properties
    
    var defaults = UserDefaults.standard
    var mainMenus = ["Shop auction sales", "Payment", "Withdraw", "Deposit cryptos", "My orders", "My lists", "My auctions", "Message", "Support", "Logout"]
    var mainMenuImages = [#imageLiteral(resourceName: "eye"), #imageLiteral(resourceName: "seller"),#imageLiteral(resourceName: "packages"), #imageLiteral(resourceName: "star"),#imageLiteral(resourceName: "shopping"), #imageLiteral(resourceName: "myads"),#imageLiteral(resourceName: "seller"), #imageLiteral(resourceName: "comments"), #imageLiteral(resourceName: "speaker"),#imageLiteral(resourceName: "logout")]
    var otherMenus = ["Support", "Logout"]
    var othersArrayImages = [#imageLiteral(resourceName: "speaker"),#imageLiteral(resourceName: "logout")]
    
    var viewHome: UITabBarController!
    var viewShop: UIViewController!
    var viewAuction: UIViewController!
    var viewPayment: UIViewController!
    var viewWithdraw: UIViewController!
    var viewDepositCryptos: UIViewController!
    var viewMyOrders: UIViewController!
    var viewMyLists: UIViewController!
    var viewMyAcutions: UIViewController!
    var viewMessage: UIViewController!
    
    
    //Other Menues
    var viewSupport : UIViewController!
    var viewlogout: UIViewController!
    
    //MARK:- Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.initializeOtherViews()
        
        let data = UserDefaults.standard.object(forKey: "userAuthData")
        let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
        let userAuth = UserAuthModel(fromDictionary: objUser)
        
        self.lbUserName.text = "\(userAuth.first_name!) \(userAuth.last_name!)"
        self.lbUserEmail.text = userAuth.email
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setHeader()
    }
    
    fileprivate func initializeViews() {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        self.viewHome = mainView
        
        let viewAuction = storyboard?.instantiateViewController(withIdentifier: "AuctionVC") as! AuctionVC
        self.viewAuction = viewAuction
        
        let myAuction = storyboard?.instantiateViewController(withIdentifier: "MyAuctionPagerVC") as! MyAuctionPagerVC
        self.viewMyAcutions = myAuction
        
        let view = storyboard?.instantiateViewController(withIdentifier: "SellerPagerVC") as! SellerPagerVC
        self.viewMyLists = view
        
        let buyerview = storyboard?.instantiateViewController(withIdentifier: "BuyerPagerVC") as! BuyerPagerVC
        self.viewMyOrders = buyerview
        
        let msgView = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        self.viewMessage = msgView
        
        let card = storyboard?.instantiateViewController(withIdentifier: "CardVC") as! CardVC
        self.viewPayment = card
        
        let withdraw = storyboard?.instantiateViewController(withIdentifier: "WithdrawVC") as! WithdrawVC
        self.viewWithdraw = withdraw
        
    }

    func initializeOtherViews() {
//        let supportView = storyboard?.instantiateViewController(withIdentifier: "SupportController") as! SupportController
//        self.viewSupport = UINavigationController(rootViewController: supportView)
    }
    
    func changeMenu(_ other: MainMenu) {
        self.slideMenuController()?.closeLeft()
        switch other {
//        case .home:
//            self.slideMenuController()?.changeMainViewController(self.viewHome, close: true)
        case .auction:
            self.navigationController?.pushViewController(viewAuction, animated: true)
        case .payment:
            self.navigationController?.pushViewController(viewPayment, animated: true)
        case .withdraw:
            self.navigationController?.pushViewController(viewWithdraw, animated: true)
        case .cryptos:
            self.navigationController?.pushViewController(viewDepositCryptos, animated: true)
        case .myorders:
            self.navigationController?.pushViewController(viewMyOrders, animated: true)
        case .mylists:
            self.navigationController?.pushViewController(viewMyLists, animated: true)
        case .myauctions:
            self.navigationController?.pushViewController(viewMyAcutions, animated: true)
        case .message:
            self.navigationController?.pushViewController(viewMessage, animated: true)
        case .support :
            self.navigationController?.pushViewController(viewSupport, animated: true)
        case .logout :
            let alert = Alert.showConfirmAlert(message: "Are you sure you want to logout?", handler: { (_) in self.logoutUser()})
            self.presentVC(alert)
            
        }
    }
    
    //MARK-: Logout user
    func logoutUser() {
        self.defaults.set(false, forKey: "isLogin")
        let signinController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(signinController, animated: true)
    }
    
    @IBAction func actionEditProfile(_ sender: Any) {
//        let profileView = storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
//        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeftMenuCell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for: indexPath) as! LeftMenuCell
        let row = indexPath.row
        
        cell.lblName.text = self.mainMenus[row]
        cell.imgPicture.image = self.mainMenuImages[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        return title
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        let menu = MainMenu(rawValue: indexPath.row)!
        self.changeMenu(menu)
        

    }
}
