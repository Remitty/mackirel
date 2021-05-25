//
//  ProductTableCell.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation
import UIKit

protocol ProductDetailDelegate{
    func goToProductDetail(id : Int)
}

class ProductsTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var heightConstraintTitle: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var oltViewAll: UIButton! {
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    
    var dataArray = [ProductModel]()
    var delegate : ProductDetailDelegate?
    
    var cell:  ProductCell!

    var btnViewAll :(()->())?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        if let layout = collectionView?.collectionViewLayout as? AdaptiveCollectionLayout {
          layout.delegate = self
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    //MARK:- Custom
    
    func reloadData() {
        collectionView.reloadData()
    }
   
    //MARK:- Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let objData = dataArray[indexPath.row]
        if let imgUrl = objData.image {
//                cell.imgPicture.sd_setShowActivityIndicatorView(true)
//                cell.imgPicture.sd_setIndicatorStyle(.gray)
//                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            cell.imgPicture.load(url: URL(string: imgUrl)!)
        }
        
//        if let name = objData.adTitle {
//            cell.lblName.text = name
//        }
//        if let location = objData.adLocation.address {
//            cell.lblLocation.text = location
//        }
//
//        if let price = objData.adPrice.price {
//            cell.lblPrice.text = price
//        }
//        cell.btnFullAction = { () in
//            self.delegate?.goToAddDetail(ad_id: objData.adId)
//        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let totalHeight = 150.0
//            let totalWidth: CGFloat = (self.frame.width / 3)
//        return CGSize(width: floor(totalWidth), height: floor(totalHeight))
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    //MARK:- IBActions
    
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
}

extension ProductsTableCell: AdaptiveCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let objData = dataArray[indexPath.row]
        let columnWidth = self.frame.width / CGFloat(AdaptiveCollectionConfig.numberOfColumns)
        if objData.image != nil {
            let imageData: NSData =  try! NSData(contentsOf: URL(string: objData.image)!)!
            let image = UIImage(data: imageData as Data)
            let height: CGFloat = (image?.size.height)!
            let width: CGFloat = (image?.size.width)!
            let rate = width / columnWidth
            return CGFloat(height/rate)
        }
        else {
            return columnWidth
        }
        }
}
