//
//  FeaturedAdsController.swift
//  AdForest
//
//  Created by apple on 3/8/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView
import Cosmos

class FeaturedAdsController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    //MARK:- Outlets
    @IBOutlet weak var scrollBar: UIScrollView! {
        didSet {
            scrollBar.delegate = self
            scrollBar.isScrollEnabled = true
            scrollBar.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerViewProfile: UIView! {
        didSet {
            containerViewProfile.addShadowToView()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblAddType: UILabel!
    @IBOutlet weak var lblLastLogin: UILabel!
    @IBOutlet weak var imgeditProfile: UIImageView!
    
    @IBOutlet weak var buttonEditProfile: UIButton!
    
    @IBOutlet weak var containerViewAddLabel: UIView!
    @IBOutlet weak var lblSoldAds: UILabel!
    @IBOutlet weak var lblAllAds: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var lblInactiveAds: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var lblNoData: UILabel! {
        didSet {
            lblNoData.isHidden = true
        }
    }
    @IBOutlet weak var oltAdPost: UIButton!{
        didSet {
            oltAdPost.circularButton()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltAdPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    
    
    //MARK:- Properties
    var dataArray = [MyAdsAd]()
    var noAddTitle = ""
    let defaults = UserDefaults.standard
    var currentPage = 0
    var maximumPage = 0
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.adMob()
        self.adForest_featuredAdsData()
        self.googleAnalytics(controllerName: "Featured Ads Controller")
        if defaults.bool(forKey: "isGuest") {
            self.oltAdPost.isHidden = true
        }
        self.adForest_featuredAdsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if AddsHandler.sharedInstance.objMyAds == nil{
//            self.adForest_featuredAdsData()
//        }
    }
    //MARK: - Custom
    
    @objc func refreshTableView() {
        adForest_featuredAdsData()
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adForest_populateData() {
        if AddsHandler.sharedInstance.objMyAds != nil {
            let objData = AddsHandler.sharedInstance.objMyAds
            self.title = objData?.pageTitle
            
            if let imgUrl = URL(string: (objData?.profile.profileImg)!) {
                self.imgPicture.sd_setIndicatorStyle(.gray)
                self.imgPicture.sd_setShowActivityIndicatorView(true)
                self.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            if let userName = objData?.profile.displayName {
                self.lblName.text = userName
            }
            if let isAddVerified = objData?.profile.verifyButon.text {
                self.lblAddType.text = isAddVerified
            }
            if let isAddVerifiedbackgroundColor = objData?.profile.verifyButon.color {
                self.lblAddType.backgroundColor = Constants.hexStringToUIColor(hex: isAddVerifiedbackgroundColor)
            }
            if let lastLoginTime = objData?.profile.lastLogin {
                self.lblLastLogin.text = lastLoginTime
            }
            if let editProfileText = objData?.profile.editText {
                self.buttonEditProfile.setTitle(editProfileText, for: .normal)
            }
            
            if let rateBar = objData?.profile.rateBar.number {
                self.ratingBar.settings.updateOnTouch = false
                self.ratingBar.settings.fillMode = .precise
                self.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
                self.ratingBar.rating = Double(rateBar)!
            }
            if let avgRating = objData?.profile.rateBar.text {
                ratingBar.text = avgRating
            }
            
            if let soldAds = objData?.profile.adsSold {
                self.lblSoldAds.text = soldAds
            }
            if let allAds = objData?.profile.adsTotal {
                self.lblAllAds.text = allAds
            }
            if let inactiveAds = objData?.profile.adsInactive {
                self.lblInactiveAds.text = inactiveAds
            }
        }
        else {
        }
    }
    
    func adMob() {
        if UserHandler.sharedInstance.objAdMob != nil {
            let objData = UserHandler.sharedInstance.objAdMob
            var isShowAd = false
            if let adShow = objData?.show {
                isShowAd = adShow
            }
            if isShowAd {
                var isShowBanner = false
                var isShowInterstital = false
                
                if let banner = objData?.isShowBanner {
                    isShowBanner = banner
                }
                if let intersitial = objData?.isShowInitial {
                    isShowInterstital = intersitial
                }
                if isShowBanner {
                    SwiftyAd.shared.setup(withBannerID: (objData?.bannerId)!, interstitialID: "", rewardedVideoID: "")
                    
                    if objData?.position == "top" {
                        self.containerViewProfile.translatesAutoresizingMaskIntoConstraints = false
                        self.containerViewProfile.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .top)
                    }
                    else {
                        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
                        self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 70).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .bottom)
                    }
                }
                if isShowInterstital {
//                    SwiftyAd.shared.setup(withBannerID: "", interstitialID: (objData?.interstitalId)!, rewardedVideoID: "")
//                    SwiftyAd.shared.showInterstitial(from: self)
                    
                    self.perform(#selector(self.showAd), with: nil, afterDelay: Double(objData!.timeInitial)!)
                    self.perform(#selector(self.showAd2), with: nil, afterDelay: Double(objData!.time)!)
                    
                }
            }
        }
    }

    @objc func showAd(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    @objc func showAd2(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    //MARK:- Collection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray.count == 0 {
            self.collectionView.isHidden = true
            lblNoData.isHidden = false
            self.lblNoData.text = noAddTitle
        }
        collectionView.isHidden = false
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeaturedAddsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedAddsCell", for: indexPath) as! FeaturedAddsCell
        
        let objData = dataArray[indexPath.row]
        
        for images in objData.adImages {
            if let imgUrl = URL(string: images.thumb) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        
        if let addTitle = objData.adTitle {
            cell.lblName.text = addTitle
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        
        if let featuredTypeText = objData.adStatus.featuredTypeText {
            cell.lblAddType.text = featuredTypeText
            cell.lblAddType.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.featureAdd)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
        addDetailVC.isFromFeaturedAds = true
        addDetailVC.ad_id = self.dataArray[indexPath.row].adId
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            self.adForest_loadMoreData(param: param as NSDictionary)
        }        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Constants.isiPadDevice {
            let width = collectionView.bounds.width/3.0
            return CGSize(width: width, height: 200)
        }
        let width = collectionView.bounds.width/2.0
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK:- IBActions
    
    @IBAction func actionEditProfile(_ sender: Any) {
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func actionAdPost(_ sender: Any) {
        let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AadPostController") as! AadPostController
        self.navigationController?.pushViewController(adPostVC, animated: true)
    }
    //MARK:- API Calls
    //Featured ads data
    
    func adForest_featuredAdsData() {
        self.showLoader()
        AddsHandler.featuredAds(success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.noAddTitle = successResponse.message
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                AddsHandler.sharedInstance.objMyAds = successResponse.data
                self.dataArray = successResponse.data.ads
                self.adForest_populateData()
                self.collectionView.reloadData()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //Load More Data
    func adForest_loadMoreData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.moreFeaturedAdsData(param: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                AddsHandler.sharedInstance.objMyAds = successResponse.data
                self.dataArray.append(contentsOf: successResponse.data.ads)
                self.adForest_populateData()
                self.collectionView.reloadData()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}


