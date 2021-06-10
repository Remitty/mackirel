//
//  CommentVC.swift
//  Mackirel
//
//  Created by brian on 6/9/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView


protocol moveTomessagesDelegate {
    func isMoveMessages(message: String)
}

class CommentVC: UIViewController , NVActivityIndicatorViewable{

    //MARK:- Outlets
    
    @IBOutlet weak var viewMsg: UIView! {
        didSet {
            viewMsg.circularView()
        }
    }
    @IBOutlet weak var imgMessage: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewCall: UIView!
    @IBOutlet weak var containerViewTxtField: UIView!
    @IBOutlet weak var txtComment: UITextField!
   
    
    //MARK:- Properties
    var delegate: moveTomessagesDelegate?
    var objAddDetailData: ProductModel?
    let defaults = UserDefaults.standard
    var ad_id = 0
   
    
    var post_id = 0
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Comment Controller")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    //MARK:- IBActions
    @IBAction func actionBigButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.dismissVC(completion: nil)
        }
    }
    
    @IBAction func actionOK(_ sender: UIButton) {
        guard let commentField = txtComment.text else {
            return
        }
        if commentField == "" {
            self.txtComment.shake(6, withDelta: 10, speed: 0.06)
        }
        else  {
            let param: [String: Any] = ["ad_id": ad_id, "message": commentField]
            
            self.dismissVC(completion: nil)
            self.delegate?.isMoveMessages(message: commentField)
//            self.popUpMessageReply(param: param as NSDictionary)
        }
        
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.dismissVC(completion: nil)
        }
    }

    // pop up message reply
    func popUpMessageReply(param: NSDictionary) {
        self.showLoader()
//        AddsHandler.popMsgReply(param: param, success: { (successResponse) in
//            self.stopAnimating()
//            if successResponse.success {
//                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
//                    self.dismissVC(completion: {
//                        self.delegate?.isMoveMessages(isMove: true)
//                    })
//                })
//                self.presentVC(alert)
//            } else {
//                let alert = Constants.showBasicAlert(message: successResponse.message)
//                self.presentVC(alert)
//            }
//        }) { (error) in
//            self.stopAnimating()
//            let alert = Constants.showBasicAlert(message: error.message)
//            self.presentVC(alert)
//        }
    }
    
}
