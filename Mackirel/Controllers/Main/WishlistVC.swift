//
//  WishlistVC.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation
import UIKit

class WishlistVC: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        }
    }
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    
    var dataArray = [FavModel]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
        
        dataArray = DBFav().getUserFavs()
        if dataArray.count > 0 {
            lbEmpty.isHidden = true
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        
        if let layout = collectionView?.collectionViewLayout as? AdaptiveCollectionLayout {
          layout.delegate = self
        }
    }
    
}

extension WishlistVC: AdaptiveCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 210
    }
}

extension WishlistVC: UICollectionViewDelegateFlowLayout {
    
    
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

extension WishlistVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let objData = dataArray[indexPath.row]
        
        if let imgUrl = objData.image {
            cell.imgPicture.load(url: URL(string: imgUrl)!)
        }
        
        cell.imgFav.setImage(UIImage(systemName: "heart.fill"), for: .normal)

        cell.btnActionFull = { () in
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            addDetailVC.ad_id = objData.id
            self.navigationController?.pushViewController(addDetailVC, animated: true)
        }
        
        cell.addFav = { () in
            if DBFav().deleteFav(id: objData.id) {
                self.dataArray.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }
            
        }
        
        return cell
    }

    
    
}
