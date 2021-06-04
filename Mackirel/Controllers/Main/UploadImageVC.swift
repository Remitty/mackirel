//
//  UploadImageVC.swift
//  Mackirel
//
//  Created by brian on 5/20/21.
//

import UIKit
import Photos
import NVActivityIndicatorView
import Alamofire
import OpalImagePicker
import UITextField_Shake
import JGProgressHUD

class UploadImageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, OpalImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   //textViewValueDelegate
  
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            
            
        }
    }
    
    
    
    //MARK:- Properties
    
    private lazy var uploadingProgressBar: JGProgressHUD = {
        let progressBar = JGProgressHUD(style: .dark)
        progressBar.indicatorView = JGProgressHUDRingIndicatorView()
        progressBar.textLabel.text = "Uploading"
        return progressBar
    }()
    
    var imageUrl:URL?
    
    var photoArray = [UIImage]()
   
    var imageArray = [ProductImage]()
    

    var adID = 0
    var imageIDArray = [Int]()

    var haspageNumber = ""
    
    var dataArray = [ProductModel]()
    var valueArray = [String]()
    var maximumImagesAllowed = 0
    var localVariable = ""
    var localDictionary = [String: Any]()
    var isfromEditAd = false
    let defaults = UserDefaults.standard
    
    var isFromAddData = ""
    var popUpTitle = ""
    var selectedIndex = 0
    
    var isValidUrl = false
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.showBackButton()
//        self.hideKeyboard()
        
//        self.populateData()
    
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    //MARK:- table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if section == 0 {
            returnValue =  1
        }
        else if section == 1 {
              returnValue =  1
        }
        
      return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell: UploadImageCell = tableView.dequeueReusableCell(withIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell
           
            cell.btnNext = { () in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostProductVC") as! PostProductVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.btnUploadImage = { () in
                
                let actionSheet = UIAlertController(title: "Select", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
                    let imagePickerConroller = UIImagePickerController()
                    imagePickerConroller.delegate = self
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        imagePickerConroller.sourceType = .camera
                    }else{
                        let alert = UIAlertController(title: "Alert", message: "camera not available", preferredStyle: UIAlertController.Style.alert)
                        let OkAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(OkAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.present(imagePickerConroller,animated:true, completion:nil)
                }))
                actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
                  
                    let imagePicker = OpalImagePickerController()
                    imagePicker.navigationBar.tintColor = UIColor.white
                    imagePicker.maximumSelectionsAllowed = self.maximumImagesAllowed
                    print(self.maximumImagesAllowed)
                    imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
                    // maximum message
                    let configuration = OpalImagePickerConfiguration()
//                    configuration.maximumSelectionsAllowedMessage = NSLocalizedString((objData?.data.images.message)!, comment: "")
                    imagePicker.configuration = configuration
                    imagePicker.imagePickerDelegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                
                }))
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
                }))
//                if Constants.isiPadDevice {
//                    actionSheet.popoverPresentationController?.sourceView = cell.containerView
//                    actionSheet.popoverPresentationController?.sourceRect = cell.containerView.bounds
//                    self.present(actionSheet, animated: true, completion: nil)
//                }else{
//                    self.present(actionSheet, animated: true, completion: nil)
//                }
                self.present(actionSheet, animated: true, completion: nil)
            }
            return cell
        }
            
        else if section == 1 {
            let cell: CollectionImageCell = tableView.dequeueReusableCell(withIdentifier: "CollectionImageCell", for: indexPath) as! CollectionImageCell
             
            cell.dataArray = self.imageArray
            cell.collectionView.reloadData()
            return cell
        }
            

        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height : CGFloat = 0
        if section == 0 {
            height = 100
        } else if section == 1 {
            if imageArray.isEmpty {
                height = 0
            } else {
                height = 140
            }
        
        }
        return height
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {

        if images.isEmpty {
        }
        else {
            self.photoArray = images
            let param: [String: Any] = [ "ad_id": String(adID)]
            print(param)
            self.uploadImages(param: param as NSDictionary, images: self.photoArray)
        }
            presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        self.dismissVC(completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage) != nil {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
    
                self.photoArray = [pickedImage]
                let param: [String: Any] = [ "ad_id": String(adID)]
                print(param)
                self.uploadImages(param: param as NSDictionary, images: self.photoArray)
                
            }
            dismiss(animated: true, completion: nil)
           
        }
    }
    
   
    //MARK:- API Call
    
    //post images
    
    func uploadImages(param: NSDictionary, images: [UIImage]) {
//        self.showLoader()
        self.startAnimating()
        uploadingProgressBar.progress = 0.0
        uploadingProgressBar.detailTextLabel.text = "0% Completed"
        uploadingProgressBar.show(in: view)
        
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            self.uploadingProgressBar.dismiss(animated: true)
            self.stopAnimating()
            let dictionary = successResponse as! [String: Any]
            var image: ProductImage!
            
            if let data = dictionary["data"] as? [[String: Any]] {
                self.imageArray = [ProductImage]()
                for item in data {
                    image = ProductImage(fromDictionary: item)
                    self.imageArray.append(image)
                    self.imageIDArray.append(image.imgId)
                }
                self.tableView.reloadData()
            }
            
            
        }) { (error) in
            self.stopAnimating()
            let alert = Alert.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
     func adPostUploadImages(parameter: NSDictionary , imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(Any?)-> Void, failure: @escaping(NetworkError)-> Void) {
                
        NetworkHandler.uploadImageArray(url: Constants.URL.POST_NEW_PRODCT_IMAGE, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            let currentProgress = Float(uploadProgress)/100
            self.uploadingProgressBar.detailTextLabel.text = "\(uploadProgress)% Completed"
            self.uploadingProgressBar.setProgress(currentProgress, animated: true)
        }, success: { (successResponse) in
            
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
}


