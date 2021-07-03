//
//  MyProductsVC.swift
//  Mackirel
//
//  Created by brian on 7/2/21.
//


import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class MyProductsVC: UIViewController, IndicatorInfoProvider, NVActivityIndicatorViewable {
    var itemInfo: IndicatorInfo = "PRODUCTS"
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(UINib(nibName: "MyProductItem", bundle: nil), forCellWithReuseIdentifier: "MyProductItem")
        }
    }
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    
    var productList = [ProductModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AdaptiveCollectionConfig.numberOfColumns = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let layout = collectionView?.collectionViewLayout as? AdaptiveCollectionLayout {
          layout.delegate = self
        }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
}

extension MyProductsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK:- Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productList.count > 0 {
            self.lbEmpty.isHidden = true
            self.collectionView.isHidden = false
        } else {
            self.lbEmpty.isHidden = false
            self.collectionView.isHidden = true
        }
        return productList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  MyProductItem = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProductItem", for: indexPath) as! MyProductItem
        
        let item = productList[indexPath.row]
        if item.image != nil {
            cell.image.load(url: URL(string: item.image)!)
        }
        
        cell.lbPrice.text = PriceFormat(amount: item.price, currency: .usd).description
        cell.lbShipPrice.text = PriceFormat(amount: item.shipPrice, currency: .usd).description
        if item.isShipping {
            cell.shipView.isHidden = false
        } else {
            cell.shipView.isHidden = true
        }
        if !item.isFeatured {
            cell.timerView.isHidden = true
        }
        cell.lbTitle.text = item.title
        cell.lbDate.setTitle(item.date.date, for: .normal)
        cell.lbCount.text = "\(item.qty!) Remaining"
        
        return cell
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension MyProductsVC: AdaptiveCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 280
    }
}
