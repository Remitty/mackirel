//
//  SearchSectionCell.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import Foundation

import UIKit

class SearchSectionCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtSearch: UITextField!{
        didSet {
            txtSearch.delegate = self
        }
    }
    @IBOutlet weak var oltSearch: UIButton!
    
    @IBOutlet weak var containerViewtextField: UIView! {
        didSet {
            containerViewtextField.roundCorners()
        }
    }
    
    
    //MARK:- Properties
    
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    
    }
    
  
    
    
    //MARK:- TextField Deletage
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSearch {
            txtSearch.resignFirstResponder()
            categoryDetail()
        }
        return true
    }
    
    //MARK:- Custom
    func categoryDetail() {
        guard let searchText = txtSearch.text else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        categoryVC.searchText = searchText
        categoryVC.isFromTextSearch = true
//        self.viewController()?.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- IBActions
    @IBAction func actionSearch(_ sender: UIButton) {
        categoryDetail()
    }
}
