//
//  MyAuctionPagerVC.swift
//  Mackirel
//
//  Created by brian on 6/11/21.
//
import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class MyAuctionPagerVC: SegmentedPagerTabStripViewController, NVActivityIndicatorViewable {
    var isReload = false
    var postList = [AuctionModel]()
    var bidList = [AuctionModel]()
    var winList = [AuctionModel]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        settings.style.segmentedControlColor = .green
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.looadData()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newPost))

        let child1 = self.storyboard?.instantiateViewController(withIdentifier: "MyPostAuctionVC") as! MyPostAuctionVC
        let child2 = self.storyboard?.instantiateViewController(withIdentifier: "MyBidAuctionVC") as! MyBidAuctionVC
        let child3 = self.storyboard?.instantiateViewController(withIdentifier: "MyWinAuctionVC") as! MyWinAuctionVC
        
        
        child1.auctionList = postList
        child2.auctionList = bidList
        child3.auctionList = winList
        
        return [child1, child2, child3]

        
    }
    
    func looadData() {
        let param : [String : Any] = [:]
        self.startAnimating()
        self.startAnimating()
        RequestHandler.getRequest(url: Constants.URL.AUCTION_LIST, params: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            
            var auction : AuctionModel!
            
            if let data = dictionary["post_auction"] as? [[String:Any]] {
                
                self.postList = [AuctionModel]()
                
                for item in data {
                    auction = AuctionModel(fromDictionary: item)
                    self.postList.append(auction)
                }
            }
            if let data = dictionary["bid_auction"] as? [[String:Any]] {
                
                self.bidList = [AuctionModel]()
                
                for item in data {
                    auction = AuctionModel(fromDictionary: item)
                    self.bidList.append(auction)
                }
            }
            if let data = dictionary["wining_auction"] as? [[String:Any]] {
                
                self.winList = [AuctionModel]()
                
                for item in data {
                    auction = AuctionModel(fromDictionary: item)
                    self.winList.append(auction)
                }
            }
            
            
            self.reloadPagerTabStripView()
                    
        }) { (error) in
            let alert = Alert.showBasicAlert(message: error.message)
                    self.presentVC(alert)
        }
        
    }
    
    @objc func newPost() {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadImageVC") as! UploadImageVC
        vc.isPostProduct = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

