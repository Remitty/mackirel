//
//  ProductCell.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

import UIKit

protocol SimilarProductsTableCellDelegate {
    func goToDetailProduct(id: Int)
}


class SimilarProductsTableCell: UIView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource  = self
            
        }
    }
    
    //MARK:- Properties
    var delegate: SimilarProductsTableCellDelegate?
    var relatedAddsArray = [ProductModel]()
    

    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedAddsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let objData = relatedAddsArray[indexPath.row]
        
//        for images in objData.adImages {
//            if let imgUrl = URL(string: images.thumb) {
//                cell.imgPicture.sd_setShowActivityIndicatorView(true)
//                cell.imgPicture.sd_setIndicatorStyle(.gray)
//                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
//            }
//        }
        
    
//        cell.btnActionFull = { () in
//            self.delegate?.goToDetailAd(id: objData.adId)
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 205)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
