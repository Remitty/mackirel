//
//  ProductTableCell.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

protocol ProductsTableCellDelegate{
    func goToProductDetail(id : Int)
    func loadMore(step: Int)
    
}

class ProductsTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {

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
            collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        }
    }
    
    @IBOutlet weak var lblSectionTitle: UILabel!
    
    //MARK:- Properties
    
    var dataArray = [SimpleProductModel]()
    var delegate : ProductsTableCellDelegate?
    
    var cell:  ProductCell!
    
    var waiting = false
    var step = 0

    var btnViewAll :(()->())?
    
    var isHideFav = false
    
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
            cell.imgPicture.load(url: URL(string: imgUrl)!)
        }
        
//
        cell.btnActionFull = { () in
            self.delegate?.goToProductDetail(id: objData.id)
        }
        
        
        self.cell.imgFav.isHidden = self.isHideFav
        
        
        cell.addFav = { () in
//            self.delegate?.addFav(id: objData.id)
            if DBFav().insertFav(product: objData) {
                
                if DBFav().getUserFavIds().contains(objData.id) {
                    self.cell.imgFav.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    self.cell.imgFav.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
        
        if DBFav().getUserFavIds().contains(objData.id) {
            self.cell.imgFav.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let objData = dataArray[indexPath.row]
////        print(objData.id)
//        self.delegate?.goToProductDetail(id: objData.id)
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
//        if cell.isSelected {
//            let objData = dataArray[indexPath.row]
//            print(objData.id)
//            self.delegate?.goToProductDetail(id: objData.id)
//        }
        print(indexPath.row)
        if indexPath.row == (dataArray.count - 1)   {
//                   waiting = true
            self.step += 1
            
            self.delegate?.loadMore(step: self.step)
           }
    }
 
}

extension ProductsTableCell: AdaptiveCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let objData = dataArray[indexPath.row]
        let columnWidth = self.frame.width / CGFloat(AdaptiveCollectionConfig.numberOfColumns)
        if objData.image != nil {
            do {
                var url = URL(string: objData.image) as? URL
                if url != nil {
                    let imageData: NSData =  try NSData(contentsOf: url!)!
                    let image = UIImage(data: imageData as Data)
                    let height: CGFloat = (image?.size.height)!
                    let width: CGFloat = (image?.size.width)!
                    let rate = width / columnWidth
                    return CGFloat(height/rate)
                } else {
                    return columnWidth
                }
                
            } catch {
                return columnWidth
            }
            
        }
        else {
            return columnWidth
        }
        }
}
