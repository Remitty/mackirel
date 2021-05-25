//
//  CatsTableCell.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

import UIKit

protocol CategoryDetailDelegate {
    func goToCategoryDetail(id: Int)
}

class CatsTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
//            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
//            if Constants.isiPadDevice {
//                collectionView.isScrollEnabled = true
//                collectionView.showsHorizontalScrollIndicator = false
//            }else {
//                 collectionView.isScrollEnabled = false
//            }
//            if Constants.isiPadDevice {
//                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
//                    layout.scrollDirection = .horizontal
//                }
//            }
        }
    }
    @IBOutlet weak var oltViewAll: UIButton! {
        didSet{
            oltViewAll.roundCornors(radius: 5)
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    
    //MARK:- Properties
    var categoryArray = [CatModel]()
    var delegate : CategoryDetailDelegate?
    var btnViewAll: (()->())?
    
    var numberOfColums: CGFloat = 0
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    //MARK:- Collection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as! CatCell
        let objData = categoryArray[indexPath.row]
    
        if let name = objData.name {
            cell.lblName.text = name
        }
        if let imgUrl = URL(string: objData.img) {
//            cell.imgPicture.sd_setShowActivityIndicatorView(true)
//            cell.imgPicture.sd_setIndicatorStyle(.gray)
//            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            cell.imgPicture.load(url: imgUrl)
        }
        
        cell.btnFullAction = { () in
            self.delegate?.goToCategoryDetail(id: objData.id)
        }
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if numberOfColums == 3 {
////            if Constants.isiPadDevice {
//                return CGSize(width: self.frame.width / 5 - 5, height: 170)
////            }
////            else if Constants.isIphonePlus {
////                let itemWidth = CollectionViewSettings.getItemWidth(boundWidth: collectionView.bounds.size.width)
////                return CGSize(width: itemWidth - 10, height: itemWidth)
////            }
////            else {
////                let itemWidth = CollectionViewSettings.getItemWidth(boundWidth: collectionView.bounds.size.width)
////                return CGSize(width: itemWidth, height: itemWidth + 10)
////            }
//        } else {
////            if Constants.isiPadDevice {
//                return CGSize(width: self.frame.width / 5 - 5, height: 170)
////            }
////            else if Constants.isiPhone5 {
////                let itemWidth = CollectionViewForuCell.getItemWidth(boundWidth: collectionView.bounds.size.width)
////                return CGSize(width: itemWidth, height: itemWidth + 40)
////            }
////            else if Constants.isIphonePlus {
////                let itemWidth = CollectionViewForuCell.getItemWidth(boundWidth: collectionView.bounds.size.width)
////                return CGSize(width: itemWidth, height: itemWidth + 30)
////            }
////            else {
////                let itemWidth = CollectionViewForuCell.getItemWidth(boundWidth: collectionView.bounds.size.width)
////                return CGSize(width: itemWidth, height: itemWidth + 30)
////            }
//        }
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK:- IBActions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
}
