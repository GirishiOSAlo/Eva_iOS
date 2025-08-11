//
//  AddPostVC.swift
//  EvaConnect
//
//  Created by Metis on 27/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import URLEmbeddedView
import SDWebImage
import Alamofire
import AVKit
import AVFoundation
import MobileCoreServices
import WebKit
import Photos
import PhotosUI

@IBDesignable
class AddPostVC: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var postFileBtn: UIButton!
    @IBOutlet weak var contentTxtView1: UITextView!
    @IBOutlet weak var contentTxtView2: UITextView!
    @IBOutlet weak var contentTxtView3: UITextView!
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var placeHolderLbl1: UILabel!
    @IBOutlet weak var placeHolderLbl2: UILabel!
    
    @IBOutlet weak var urlPreviewImg: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
//    @IBOutlet weak var profileView: UIView!
//    @IBOutlet weak var urlView: UIView!
    
    @IBOutlet weak var MainImageView: UIView!
    @IBOutlet weak var MainUrlView: UIView!
    @IBOutlet weak var MainVideoView: UIView!
    @IBOutlet weak var videoContentView: UIView!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var removeVideo: UIButton!
    @IBOutlet weak var galleryImageBtn: UIButton!
    @IBOutlet weak var adddocBtn: UIButton!
    @IBOutlet weak var selectArticleBtn: UIButton!
//    @IBOutlet weak var documentView: UIView!
//    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var openArticleBtn: UIButton!
    @IBOutlet weak var web: WKWebView!
    @IBOutlet weak var removeDocument: UIButton!
    @IBOutlet weak var documentView: UIView!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var docNameLbl: UILabel!
    @IBOutlet weak var docSizeLbl: UILabel!
    @IBOutlet weak var docTimeLbl: UILabel!
    @IBOutlet weak var docIconView: UIView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var collectionHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var buttonViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var bottomPhotosBtn: UIButton!
    @IBOutlet weak var bottomVideoBtn: UIButton!
    @IBOutlet weak var bottomDocBtn: UIButton!
    @IBOutlet weak var bottomBtnView: UIView!
    @IBOutlet weak var primaryBtnView: UIView!
    
    //MARK: VARIABLES
    var textIsNotOk = true
    weak var delegate: RefreshUpdateable?
    var selectedVideoUrl: URL?
    var isUrlCheck = false
    var content: String = ""
    var pickedMedia: Media?
    var arrayCount: Int!
    var selectedIndices:[Int] = [Int]()
//    var playerViewController: AVPlayerViewController?
    var myplayer: AVPlayer?
    let maxSizeInBytes = 2 * 1024 * 1024
    var postImages: [UIImage] = [] {
        didSet {
            
            if postImages.count > 0 {
                DispatchQueue.main.async {
                    self.primaryBtnView.isHidden = true
                    self.buttonViewHeightConst.constant = 0
                    self.bottomBtnView.isHidden = false
                    self.galleryImageBtn.isHidden = false
                    self.bottomDocBtn.isHidden = true
                    self.bottomPhotosBtn.isHidden = false
                    self.bottomVideoBtn.isHidden = true
                    self.collectionView.isHidden = false
                    
                    self.playPauseBtn.isHidden = true
                    self.collectionView.reloadData()
                }
            }
            else {
                self.collectionView.isHidden = true
            }
        }
    }
    var imageArray: [String] = []
    var postType: PostType = .simpleText
    var checkMediaType : String = ""
    var sizeCheck = false
    var cvURL: URL?
    var mode: PostLoadingMode = .create
    var postDetail: PostDetail? {
        didSet {
//            renderPostDetail(post: postDetail)
        }
    }
    var postId = -1
    var isArticleChange = false
    var isChanged = false
    var path: String!
    var selectedIndex = -1
    enum PostType {
        case image, article, videoURL, simpleText
    }
    var oldPostImages: [UIImage] = []
    var filterPostImages: [UIImage] = []
    var newPostImages: [UIImage] = []
    var didImageChange: Bool = false
    
    var selectedImages: [UIImage] = []
    var videoUrl: URL?
    private var documentURL: URL? = nil
    
    var imagePicker = UIImagePickerController()
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        imagePicker.delegate = self
        setLayOut()
        clearMemory()
        self.navigationController?.title = ""
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            self.collectionHeightConst.constant = self.collectionView.contentSize.height == 0 ? 100 : self.collectionView.contentSize.height
        }
    }
    
    @IBAction func bottomPhotoBtnTap(_ sender: UIButton) {
        if #available(iOS 14, *) {
            self.selectMultiple()
        } else {
            // Fallback on earlier versions
            self.addNewPicture()
        }
    }
    
    @IBAction func bottomVideoBtnTap(_ sender: UIButton) {
        self.showVideoPicker()
    }
    
}
extension AddPostVC {
    
    private func handleViews(post: PostType) {
        
        switch post {
        case .article:
            navTitle.text = "Share an Article"
            postFileBtn.setTitle("Share an Article", for: .normal)
            MainVideoView.isHidden = true
            playPauseBtn.isHidden = true
            MainImageView.isHidden = true
            MainUrlView.isHidden = false
            selectArticleBtn.isHidden = false
            view.bringSubviewToFront(MainVideoView)
            galleryView.isHidden = false
            documentView.isHidden = true
            removeDocument.isHidden = true
            removeDocument.addTarget(self, action:#selector(removeArticle(sender:)), for: .touchUpInside)
            
        case .videoURL:
            navTitle.text = "Share Video"
            postFileBtn.setTitle("Share Video", for: .normal)
            MainVideoView.isHidden = false
            MainImageView.isHidden = true
            playBtn.addTarget(self, action:#selector(showVideoView(sender:)), for: .touchUpInside)
            removeVideo.addTarget(self, action:#selector(removeVideo(sender:)), for: .touchUpInside)
            MainUrlView.isHidden = true
           
            buttonCustomization(actionBtn: removeVideo, setClipsBound: false, giveShadow: false,borderColor: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1), addBorder: true)
            view.bringSubviewToFront(MainVideoView)
            galleryImageBtn.setTitle("Video", for: .normal)
            galleryView.isHidden = false
        
        default:
            
            navTitle.text = "New Post"
            postFileBtn.setTitle("Create Post", for: .normal)
            MainVideoView.isHidden = true
            playBtn.isHidden = true
            MainImageView.isHidden = false
        }
    }
    
    func handleMode(mode: PostLoadingMode) {
        switch mode {
        case .create:
            break
        case .edit:
            postDetail(postId: postId)
            break
       }
    }
//    func renderPostDetail(post: PostDetail?){
//        guard let post = post else {
//            return
//        }
//        if post.postImage!.count > 0 {
//            handleViews(post: .image)
//            postFileBtn.setTitle("Edit Post", for: .normal)
//            for i in post.postImage! {
//                let url = URL(string: i)
//                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist,
//                postImages.append(UIImage(data: data!)!)
//            }
//            arrayCount = postImages.count
//            oldPostImages = postImages
//            isChanged = false
//            content = post.content ?? ""
//            postFileBtn.isEnabled = true
//            postFileBtn.alpha = 1.0
//            contentTxtView2.text = content
//            if !contentTxtView2.text.isNilOrEmpty {
//                placeHolderLbl1.isHidden = true
//            }
//            else {
//                placeHolderLbl1.isHidden = false
//            }
//            self.checkMediaType = "image"
//            self.collectionView.isHidden = false
//            //self.sizeCheck = true
//            //self.UploadImage.image = image1
//            self.postFileBtn.isEnabled = true
//            self.postFileBtn.alpha = 1.0
//            //self.mainView.isHidden = false
//           // print("Image\(orignalImage!)")
//        }
//        else if post.postDocument != nil {
//            handleViews(post: .article)
//            postFileBtn.setTitle("Edit Article", for: .normal)
//            content = post.content ?? ""
//            contentTxtView3.text = content
//            if !contentTxtView3.text.isNilOrEmpty {
//                placeHolderLbl2.isHidden = true
//            }
//            else{
//                placeHolderLbl2.isHidden = false
//            }
//            loadArticleForPreview(article: post.postDocument)
//            path = post.postDocument!
//            documentName.text = post.postDocument?.fileName()
//            openArticleBtn.addTarget(self, action: #selector(openArticle), for: .touchUpInside)
//            documentView.isHidden = false
//            removeDocument.isHidden = false
//            isUrlCheck = true
//            postFileBtn.isEnabled = true
//            postFileBtn.alpha = 1
//        }
//        else if post.postVideo != nil {
//            handleViews(post: .videoURL)
//            postFileBtn.setTitle("Edit Video", for: .normal)
//            content = post.content ?? ""
//            self.checkMediaType = "video"
//            self.videoView.configure(url: post.postVideo!,ratio: .resizeAspect)
//            self.videoView.isLoop = false
//            path = post.postVideo!
//            videoView.stop()
//            showVideo()
//            isChanged = false
//            self.videoView.backgroundColor = .clear
//            contentTxtView1.text = content
//            if !contentTxtView1.text.isNilOrEmpty {
//                placeHolderLbl.isHidden = true
//            }
//            else {
//                placeHolderLbl.isHidden = false
//            }
//            //let videoData = try? Data(contentsOf: selectedVideo)
//            //pickedMedia = FileHandler.createTempMedia(with: videoData!, format: .MOV)
//            print("*****Video Found")
//            self.postFileBtn.isEnabled = true
//            self.postFileBtn.alpha = 1.0
//        }
//        else {
//            handleViews(post: .image)
//            postFileBtn.setTitle("Edit Post", for: .normal)
//            content = post.content ?? ""
//            contentTxtView2.text = content
//            if !contentTxtView2.text.isNilOrEmpty{
//                placeHolderLbl1.isHidden = true
//            }
//            else {
//                placeHolderLbl1.isHidden = false
//            }
//
//            textIsNotOk = false
//            postFileBtn.isEnabled = true
//            postFileBtn.alpha = 1.0
//        }
//    }
    
    func selectMedia() {
        let alert = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (UIAlertAction) in
            
            if #available(iOS 14, *) {
                self.selectMultiple()
            } else {
                // Fallback on earlier versions
                self.addNewPicture()
            }
            
            self.videoUrl = nil
            self.videoView.isHidden = true
            self.playPauseBtn.isHidden = true
            self.documentView.isHidden = true
            self.documentURL = nil
        }))
        
        alert.addAction(UIAlertAction(title: "Videos", style: .default, handler: { (UIAlertAction) in
            self.showVideoPicker()
            self.postImages = []
            self.documentView.isHidden = true
            self.documentURL = nil
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension AddPostVC {
    
    @IBAction func addPost(_ sender: Any) {
    
        if contentTxtView2.text.count > 0  && contentTxtView2.text.count != 0 && !contentTxtView2.text.isEmpty {
            postFileBtn.isEnabled = true
            postFileBtn.backgroundColor = AppColors.appBlue
            placeHolderLbl1.isHidden = true
            content = "\(contentTxtView2.text!)"
            createPost(isUrl: false, post: postType)
        } else {
            postFileBtn.isEnabled = false
            placeHolderLbl1.isHidden = false
            postFileBtn.backgroundColor = UIColor(hex: "#C3CCDF", alpha: 1)
        }

        
//        if self.isUrlCheck == true {
//            if mode == .create {
//                createPost(isUrl: true, post: .article)
//            }
//            else {
////                updatePost(isUrl: true, post: .article)
//            }
//        } else {
//
//            if checkMediaType == "image" {
//                if mode == .create {
//                    createPost(isUrl: false, post: .image)
//                }
//                else {
////                    updatePost(isUrl: false, post: .image)
//                }
//
//            } else if checkMediaType == "video"{
//                if mode == .create {
//                    createPost(isUrl: false, post: .videoURL)
//                }
//                else {
////                    updatePost(isUrl: false, post: .videoURL)
////                    if isVideoChange == false {
////
////                    }
////                    else {
////                        self.presentAlert("Error", "Please select Video for Post", nil)
////
////                    }
//                }
//
//            } else {
//                if textIsNotOk == false {
//                    if mode == .create {
//                        createPost(isUrl: false, post: .simpleText)
//                    }
//                    else {
////                        updatePost(isUrl: false, post: .simpleText)
//                    }
//                }
//                else{
//                    self.presentAlert("Error", "Please Write Someting", nil)
//                }
//
//            }
//
//        }
    }
    
    @IBAction func openGallery(_ sender: Any) {
        selectMedia()

    }
    
    @IBAction func addDocTapped(_ sender: UIButton) {
        
        openFile()
        //        }
    }

    @IBAction func openCamera(_ sender: Any) {
        if postType == .image {
            openCameraImageOnly()
        } else {
            openCameraVideoOnly()
        }
        
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func openDocument(_ sender: Any) {
    
        openFile()
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
    
        myplayer?.play()
    }
}

//MARK: Video Image delegates
//extension AddPostVC {
//    func showVideoPicker() {
//            let status = PHPhotoLibrary.authorizationStatus()
//            if status == .authorized {
//                imagePicker.sourceType = .photoLibrary
//                imagePicker.mediaTypes = [kUTTypeMovie as String]
//                present(imagePicker, animated: true, completion: nil)
//            } else if status == .denied || status == .restricted {
//                // Handle denied or restricted authorization
//                print("Access to photo library is denied or restricted.")
//            } else {
//                // Request authorization
//                PHPhotoLibrary.requestAuthorization { [weak self] status in
//                    if status == .authorized {
//                        DispatchQueue.main.async {
//                            self?.showVideoPicker()
//                        }
//                    } else {
//                        // Handle denied or restricted authorization
//                        print("Access to photo library is denied or restricted.")
//                    }
//                }
//            }
//        }
//
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            dismiss(animated: true, completion: nil)
//
//            if let mediaType = info[.mediaType] as? String {
//                if mediaType == kUTTypeMovie as String {
//                    if let videoURL = info[.mediaURL] as? URL {
//                        encodeVideoToBase64(videoURL: videoURL)
//                    }
//                }
//            }
//        }
//
//        func encodeVideoToBase64(videoURL: URL) {
//            PHPhotoLibrary.shared().performChanges({
//                let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
//                request?.creationDate = Date()
//            }) { success, error in
//                if success {
//                    let asset = PHAsset.fetchAssets(withLocalIdentifiers: [videoURL.absoluteString], options: nil).firstObject
//                    let options = PHImageRequestOptions()
//                    options.isSynchronous = true
//
//                    PHImageManager.default().requestImageData(for: asset!, options: options) { (data, _, _, _) in
//                        if let videoData = data {
//                            let base64String = videoData.base64EncodedString()
//                            print("Base64 encoded video:\n\(base64String)")
//                            // Now you can send the base64String to your server or use it as needed
//                        }
//                    }
//                } else {
//                    print("Failed to create a PHAsset: \(error?.localizedDescription ?? "")")
//                }
//            }
//        }
//
//}

extension AddPostVC {
    
    //MARK: ApiCALLING
    private func createPost(isUrl: Bool, post: PostType) {
        
        var parameters: AFParameters = [ "user_id" : myUserDefaults.userId, // LoggedUserDetails.shared.user!.id ?? 0,
                                         "created_by_id" : myUserDefaults.userId, // LoggedUserDetails.shared.user!.id ?? 0,
                                         "status": "pending",
                                         "content": content,
                                         "is_url": isUrl ]
        
        
//        if let userImage = self.signUpDetails.userImage {
//            if let imageData = userImage.jpegData(compressionQuality: 0.8) {
//                let base64ImageString = imageData.base64EncodedString(options: [])
//                parameters["post_image"] = "data:image/png;base64,\(base64ImageString)"
//
//            }
//        }
        
        switch postType {
        case .image :
            if self.postImages.count > 0 {

                self.postImages.enumerated().forEach { (index, mediaImage) in
                    if let imageData = mediaImage.jpegData(compressionQuality: 1.0) {
                        let base64ImageString = imageData.base64EncodedString(options: [])
                        imageArray.append("data:image/png;base64,\(base64ImageString)")
                    }
                }
               
            }else {
                presentAlert("Error:", "Something went wrong")
                return
            }
            parameters["post_image"] = imageArray
        case .videoURL:
            if let myVideoUrl = videoUrl {
                let base64Video = encodeVideoToBase64(URL: myVideoUrl)
                parameters["post_video"] = "data:application/mp4;base64,\(base64Video ?? "")"
            } else {
                presentAlert("Error:", "Something went wrong")
                return
            }
        case .article:
            if let myDocUrl = documentURL {
                let base64Doc = encodeVideoToBase64(URL: myDocUrl)
                if base64Doc == "" {
                    presentAlert("Error:", "Something went wrong")
                    return
                }
                parameters["post_document"] = "data:application/pdf;base64,\(base64Doc ?? "")"
                parameters["document_file_name"] = docNameLbl.text
            } else {
                presentAlert("Error:", "Something went wrong")
                return
            }
            break
        default:
            break
        }

//        if videoUrl != nil {
            showActivity()
            NetworkManagerr.request(EndPoints.newPost, method: .post, parameters: parameters) { (response) in

                if response.result.isSuccess {

                    do {
                        let genericRoot = try JSONDecoder().decode(GenericResponse.self, from: response.data!)
                        if genericRoot.error {
                            self.hideActivity()
                            self.makeAlert(messageData: genericRoot.message)
                            
                        } else {
                            self.hideActivity()
                            self.delegate?.refresh(homeStatus: true)
                            self.clearMemory()
                            self.back_touchUpInside(self.backBtn)
                        }
                    } catch let error {
                        self.hideActivity()
                        self.makeAlert(messageData: error.localizedDescription)
                    }
                    
                } else {
                    self.hideActivity()
    //                completion(nil, response.result.error)
                }
            }
//        } else {
//            presentAlert("Error!", "Could not add the video")
//        }
        
        
//        showActivity()
//
//        Alamofire.upload(multipartFormData: { (multiFormData) in
//
//            for (key, value) in parameters {
//                multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//            }
//            switch post {
//            case .image:
//
//                if self.postImages.count > 0 {
//
//                    self.postImages.enumerated().forEach { (index, mediaImage) in
//                        let imageData = mediaImage.jpegData(compressionQuality: 0.50)
//                        multiFormData.append(imageData!, withName: "post_image", fileName: "Chat_image\(index).jpg", mimeType: "image/png")
//                    }
//                }
//
//               //break
//            case .videoURL:
//
//                multiFormData.append(self.selectedVideoUrl!, withName: "post_video")
//               // break
//            case .article:
//
//                let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                let documentsDirectory = directory.appendingPathComponent("EvaDocuments")
//
//                let sandboxFileUrl = documentsDirectory.appendingPathComponent(self.cvURL!.lastPathComponent)
//
//                if FileManager.default.fileExists(atPath: sandboxFileUrl.path) {
//
//                    let pdfData = try? Data(contentsOf: sandboxFileUrl)
//                    multiFormData.append(pdfData!, withName: "post_document", fileName: self.cvURL!.lastPathComponent, mimeType: "pdf")
//
//                }
//
//                else {
//                    print("file doesn't exist there")
//                    break
//                }
//
//           // break
//            default://simple
//                break
//            }
//
//        }, to: EndPoints.newPost, headers: SharedHeaders.headers) { (result) in
//            switch result {
//
//            case .success(let upload, _, _):
//
//                upload.responseJSON { (response) in
//                    self.hideActivity()
//                    if response.result.isSuccess {
//                        let jsonDecoder = JSONDecoder()
//                        let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from: response.data!)
//
//                        if let genericResponse = genericResponse, !genericResponse.error {
//                            self.delegate?.refresh(homeStatus: true)
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//
//            case .failure(let error):
//                print (error.localizedDescription)
//            }
//        }
    }
//    private func updatePost(isUrl: Bool, post: PostType) {
//
//        let parameters: AFParameters = ["content": content,
//                                         "is_url": isUrl,
//                                         "modified_by_id": LoggedUserDetails.shared.user!.id,
//                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime)]
//
//        showActivity()
//        let url = "\(EndPoints.updatePost)\(postId)/"
//        Alamofire.upload(multipartFormData: { (multiFormData) in
//
//            for (key, value) in parameters {
//                multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//            }
//            switch post {
//            case .image:
//                if self.mode != .edit {
//                    if self.postImages.count > 0 {
//
//                        self.postImages.enumerated().forEach { (index, mediaImage) in
//                            let imageData = mediaImage.jpegData(compressionQuality: 0.50)
//                            multiFormData.append(imageData!, withName: "post_image", fileName: "Chat_image\(index).jpg", mimeType: "image/png")
//                        }
//                        print(self.postImages.count)
//
//                    }
//                }
//                else {
//                    if self.isChanged == true {
//                        self.newPostImages.enumerated().forEach { (index, mediaImage) in
//                            let imageData = mediaImage.jpegData(compressionQuality: 0.50)
//                            multiFormData.append(imageData!, withName: "post_image", fileName: "Chat_image\(index).jpg", mimeType: "image/png")
//                        }
//                        print(self.postImages.count)
//                    }
//                }
//
//                //break
//            case .videoURL:
//                if self.isChanged == true {
//                    multiFormData.append(self.selectedVideoUrl!, withName: "post_video")
//                }
//
//
//               // break
//            case .article:
//                if self.isArticleChange == true {
//                    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    let documentsDirectory = directory.appendingPathComponent("EvaDocuments")
//
//                    let sandboxFileUrl = documentsDirectory.appendingPathComponent(self.cvURL!.lastPathComponent)
//
//                    if FileManager.default.fileExists(atPath: sandboxFileUrl.path) {
//
//                        let pdfData = try? Data(contentsOf: sandboxFileUrl)
//                        multiFormData.append(pdfData!, withName: "post_document", fileName: self.cvURL!.lastPathComponent, mimeType: "pdf")
//
//                    }
//                }
//                else {
//                  let urll = URL(string: self.path!)
//                    let pdfData = try? Data(contentsOf: urll!)
//                    multiFormData.append(pdfData!, withName: "post_document", fileName: urll!.lastPathComponent, mimeType: "pdf")
//                }
//
////                else {
////                    print("file doesn't exist there")
////
////                }
//
//           // break
//            default://simple
//
//                break
//            }
//
//        }, to: url,method: .patch, headers: SharedHeaders.headers) { (result) in
//
//            switch result {
//
//            case .success(let upload, _, _):
//
//                upload.responseJSON { (response) in
//                    self.hideActivity()
//                    if response.result.isSuccess {
//                        let jsonDecoder = JSONDecoder()
//                        let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from: response.data!)
//
//                        if let genericResponse = genericResponse, !genericResponse.error {
//                            self.delegate?.refresh(homeStatus: true)
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//
//            case .failure(let error):
//                print (error.localizedDescription)
//            }
//
//        }
//    }
    func postDetail(postId: Int) {
        let parameters: AFParameters = [ "user_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                                         "post_id" : postId ]
        showActivity()
        NetworkManagerr.request(EndPoints.postDetails, method: .post, parameters: parameters) { (response) in
            print("\(PostManager.self) postDetail(:) requests for details")
            self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let postDetailRoot = try jsonDecoder.decode(PostDetailRoot.self, from: response.data!)
                    
                    if !postDetailRoot.error, postDetailRoot.data.count > 0 {
                        
                        let details = postDetailRoot.data[0]
                        self.postDetail = details
                        print("\(PostManager.self) postDetail(:) calling completion success")
                        
                    }
                } catch {
                    print("\(PostManager.self) postDetail(:) calling completion catch error")
                  
                }
            } else {
                print("\(PostManager.self) postDetail(:) calling completion api error: \(response.result.error)")
                
            }
        }
    }
    
    //MARK: LAYOUT SETTING
    func setLayOut() {
        
//        if let user = LoggedUserDetails.shared.user {
        if myUserDefaults.userImage != "" {
                self.userProfileImage.sd_setImage(with: URL(string: (myUserDefaults.userImage)), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
            }
            else{
                self.userProfileImage.image = #imageLiteral(resourceName: "profile")
            }
            postFileBtn.isEnabled = false
            postFileBtn.backgroundColor = UIColor(hex: "#C3CCDF", alpha: 1)
            userName.text = myUserDefaults.fullName
            designationLbl.text = Constants.getCurrentDate()
            
            MainImageView.layer.cornerRadius = 10
            postFileBtn.layer.cornerRadius = 25
            galleryImageBtn.layer.cornerRadius = 15
            adddocBtn.layer.cornerRadius = 15
            bottomPhotosBtn.layer.cornerRadius = 15
            bottomVideoBtn.layer.cornerRadius = 15
            bottomDocBtn.layer.cornerRadius = 15
            documentView.layer.cornerRadius = 15
            docIconView.layer.cornerRadius = docIconView.layer.bounds.width/2
            docTimeLbl.isHidden = true
            
//        }
        
        //Post UI Handling
        handleViews(post: postType)
        handleMode(mode: mode)
        
        
        contentTxtView1.delegate = self
        contentTxtView2.delegate = self
        contentTxtView3.delegate = self
        //contentField.delegate = self
        
        postFileBtn.isEnabled = true
        postFileBtn.alpha = 0.8
        
//        profileView.layer.cornerRadius = profileView.frame.height / 2
        makeImageRound(view: userProfileImage)
//        profileView.layer.borderWidth = 1
//        profileView.layer.borderColor = #colorLiteral(red: 0.3450980392, green: 0.5803921569, blue: 0.8666666667, alpha: 1)
        userProfileImage.layer.borderWidth = 1
        userProfileImage.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       // setCardView(view: urlView)
        
        collectionView.registerNib(cellNib: NewPostImages.self)
        collectionView.delegate = self
        collectionView.dataSource = self
//        demoCollection.registerNib(cellNib: NewPostImages.self)
//        demoCollection.delegate = self
//        demoCollection.dataSource = self
        placeHolderLbl.textColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        placeHolderLbl1.textColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        placeHolderLbl2.textColor = #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8941176471, alpha: 1)
        let layout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        
        videoView.layer.cornerRadius = 22
        videoView.clipsToBounds = true
        videoView.layer.borderColor = UIColor(hex: "#505050", alpha: 0.3).cgColor
        videoView.layer.borderWidth = 0.5
        
        playPauseBtn.isHidden = true
          
    }
    
    @available(iOS 14, *)
    func selectMultiple() {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        
        let phPickerVC = PHPickerViewController(configuration: config)
        phPickerVC.delegate = self
        DispatchQueue.main.async {
            self.present(phPickerVC, animated: true)
        }
    }
    
    func addPicker() -> UIImagePickerController{
       
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func addNewPicture() {
       picker = addPicker()
        DispatchQueue.main.async {
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    func showMediaPicker() {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(mediaPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickVideoButtonTapped(_ sender: UIButton) {
        showVideoPicker()
    }
    
    func showVideoPicker() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            present(imagePicker, animated: true, completion: nil)
        } else if status == .denied || status == .restricted {
            // Handle denied or restricted authorization
            print("Access to photo library is denied or restricted.")
        } else {
            // Request authorization
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self?.showVideoPicker()
                    }
                } else {
                    // Handle denied or restricted authorization
                    print("Access to photo library is denied or restricted.")
                }
            }
        }
    }
    
    func sendVideoAsBase64(videoURL: URL) {
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [videoURL], options: nil)
        
        guard let asset = fetchResult.firstObject else {
            print("Failed to get PHAsset for the provided URL.")
            return
        }
        
        let requestOptions = PHVideoRequestOptions()
        requestOptions.version = .original
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: requestOptions) { avAsset, _, _ in
            guard let avAsset = avAsset as? AVURLAsset else {
                print("Failed to get AVAsset")
                return
            }
            
            do {
                let videoData = try Data(contentsOf: avAsset.url)
                let base64String = videoData.base64EncodedString()
                print("Base64 encoded video:\n\(base64String)")
                
                // Now you can use the base64String in your API request or wherever needed
            } catch {
                print("Error encoding video to base64: \(error)")
            }
        }
    }
    
    func clearMemory(){
        let fileManager = FileManager.default

        // Specify the path of the compressed video file
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsDirectory.appendingPathComponent("compressedVideo.mp4")

        // Check if the file exists before attempting to delete
        if fileManager.fileExists(atPath: outputURL.path) {
            do {
                // Attempt to delete the file
                try fileManager.removeItem(at: outputURL)
                print("Compressed video file deleted successfully.")
            } catch {
                print("Error deleting compressed video file: \(error)")
            }
        } else {
            print("Compressed video file does not exist.")
        }
    }

}

extension AddPostVC: UITextFieldDelegate, UITextViewDelegate {
    
    
    //MARK: TEXTVIEW DELEGATES
    func textViewDidChange(_ textView: UITextView) {
       
        if textView.text.count > 0  && textView.text.count != 0 && !textView.text.isEmpty {
            postFileBtn.isEnabled = true
            postFileBtn.backgroundColor = AppColors.appBlue
            placeHolderLbl1.isHidden = true
            content = "\(textView.text!)"
        } else {
            postFileBtn.isEnabled = false
            placeHolderLbl1.isHidden = false
            postFileBtn.backgroundColor = UIColor(hex: "#C3CCDF", alpha: 1)
        }
    }
}

extension AddPostVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
//        print("picked mediatype = \(mediaType)")
//        if mediaType == kUTTypeImage as String {
//            let imgData = NSData(data: (info[UIImagePickerController.InfoKey.originalImage] as! UIImage).jpegData(compressionQuality: 0.8)!)
//            let imageSize: Int = imgData.count
//            print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
//
//            let editImage = info[.editedImage] as? UIImage
//            var orignalImage = info[.originalImage] as? UIImage
//            if editImage != orignalImage {
//                orignalImage = editImage
//            }
//            //chekcing size if its 4mb
//            if  imageSize <= 4194304 {
//
//
//                postImages.append(orignalImage!)
//
//
//                if mode == .edit {
//                    newPostImages.append(orignalImage!)
//                    selectedIndices.append(postImages.count - 1)
//                }
//                postFileBtn.isEnabled = true
//                postFileBtn.alpha = 1.0
//                self.didImageChange = true
//                self.checkMediaType = "image"
//                self.collectionView.isHidden = false
//                self.sizeCheck = true
//                //self.UploadImage.image = image1
//                self.postFileBtn.isEnabled = true
//                self.postFileBtn.alpha = 1.0
//                isChanged = true
//                //self.mainView.isHidden = false
//                print("Image\(orignalImage!)")
//            }
//            else {
//               if postImages.count > 0 {
//                    //self.sizeCheck = true
//                    self.postFileBtn.isEnabled = true
//                self.postFileBtn.alpha = 1.0
//               } else {
//
//                self.sizeCheck = false
//                self.postFileBtn.isEnabled = false
//                self.postFileBtn.alpha = 0.8
//               }
//
//            }
//            if sizeCheck == false {
//                dismiss(animated: true, completion: nil)
//                makeAlert(messageData: "Image File must be less than equal to 4 MB")
//            } else {
//                dismiss(animated: true, completion: nil)
//            }
//        }
//        //   dismiss(animated: true, completion: nil)
//        else if mediaType == kUTTypeMovie as String || mediaType == kUTTypeVideo as String {
//
//            let  selectedVideo: URL = ((info[UIImagePickerController.InfoKey.mediaURL] as? URL)!)
//            let dataVideo =  NSData(contentsOf: selectedVideo as URL)!
//            let byteCount = dataVideo.count
//            let displaySize = ByteCountFormatter.string(fromByteCount: Int64(byteCount), countStyle: .file)
//            let getDouble = ByteCountFormatter.Units.init(rawValue: UInt(byteCount))
//            print(getDouble.rawValue)
//            let sizeFile = Int64(byteCount)
//            print(displaySize)
//            //chekcing size if its 4mb
//            if  sizeFile <= 4194304 {
//                self.sizeCheck = true
//                self.checkMediaType = "video"
//                print(selectedVideo)
//
//                let pathString = selectedVideo.relativePath
//                print("Video\(pathString)")
//                self.selectedVideoUrl = selectedVideo
//                print(self.selectedVideoUrl!.lastPathComponent)
//
//
//                self.videoView.configure(url: selectedVideo.absoluteString,ratio: .resizeAspect)
//                self.videoView.isLoop = false
//                videoView.stop()
//                showVideo()
//                self.videoView.backgroundColor = .clear

//                let videoData = try? Data(contentsOf: selectedVideo)
//                pickedMedia = FileHandler.createTempMedia(with: videoData!, format: .MOV)
//                print("*****Video Found")
//                self.postFileBtn.isEnabled = true
//                self.postFileBtn.alpha = 1.0
//                //self.mainView.isHidden = false
//            }
//            else {
//                self.sizeCheck = false
//                self.postFileBtn.isEnabled = false
//                self.postFileBtn.alpha = 0.8
//                hideVideo()
//
//
//            }
//            if sizeCheck == false {
//                dismiss(animated: true, completion: nil)
//                makeAlert(messageData: "Video File must be less than equal to 4 MB")
//            } else {
//                dismiss(animated: true, completion: nil)
//            }
//        }
//
//
//    }

    @objc func removeImage(sender: UIButton) {

        if mode == .edit {
            postImages.remove(at: selectedIndex)
            selectedIndices.remove(at: sender.tag)
            newPostImages.remove(at: sender.tag)
            if newPostImages.count == 0 {
                isChanged = false
            }
        } else {
            postImages.remove(at: sender.tag)
        }


        print(postImages.count)
        collectionView.reloadData()


        if postImages.count == 0 {
            self.sizeCheck = false
            self.postFileBtn.isEnabled = false
            self.postFileBtn.alpha = 0.8
            self.buttonViewHeightConst.constant = 37
            self.primaryBtnView.isHidden = false
            self.bottomBtnView.isHidden = true
        }
    }

    @objc func removeVideo(sender: UIButton) {
        videoView.isHidden = true
        playBtn.isHidden = true
        removeVideo.isHidden = true
        self.sizeCheck = false
        self.postFileBtn.isEnabled = false
        self.postFileBtn.alpha = 0.8

    }
    @objc func removeArticle(sender: UIButton) {
        documentView.isHidden = true
        //playBtn.isHidden = true
        removeDocument.isHidden = true
        isUrlCheck = false
        postFileBtn.isEnabled = false
        postFileBtn.alpha = 0.8

    }
    private func hideVideo(){
        videoView.isHidden = true
        playPauseBtn.isHidden = true
        removeVideo.isHidden = true
    }

    private func showVideo(){
        videoView.isHidden = false
        playPauseBtn.isHidden = false
        removeVideo.isHidden = false
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////        if let pickedImage = info[.originalImage] as? UIImage {
////             // Assuming you have a UICollectionView to display the selected images
////        }
//
//        if let mediaType = info[.mediaType] as? String {
//            if mediaType == kUTTypeImage as String {
//                // Handle image selection
//                if let image = info[.originalImage] as? UIImage {
//                    selectedImages.append(image)
//                    postImages = selectedImages
//                    collectionView.reloadData()
//                }
//            } else if mediaType == kUTTypeMovie as String {
//                // Handle video selection
//                if let videoURL = info[.mediaURL] as? URL {
//                    playVideo(from: videoURL)
//                }
//            }
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            dismiss(animated: true, completion: nil)
//
//            if let mediaType = info[.mediaType] as? String {
//                if mediaType == kUTTypeMovie as String {
//                    if let videoURL = info[.mediaURL] as? URL {
//                        self.postType = .videoURL
////                        self.videoUrl = videoURL
//                        self.playVideo(from: videoURL)
////                        sendVideoAsBase64(videoURL: videoURL)
//                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                        let outputURL = documentsDirectory.appendingPathComponent("compressedVideo.mp4")
//                        compressVideo(inputURL: videoURL, outputURL: outputURL) { compressedURL in
//                            if let compressedURL = compressedURL {
//                                // Compression successful, use the compressed video URL
//                                print("Compression successful. Compressed video saved at \(compressedURL)")
//                                self.videoUrl = compressedURL
//                            } else {
//
//                                // Compression failed
//                                print("Compression failed.")
//                            }
//                        }
//                    }
//                }
//            }
//        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)

        // Check if the picked media is a video
        if let mediaType = info[.mediaType] as? String {
            if mediaType == kUTTypeMovie as String {
                // Get the video URL from the media info
                if let videoURL = info[.mediaURL] as? URL {
                    self.clearMemory()
                    
                        let isWithinLimit = self.isVideoSizeWithinLimit(videoURL: videoURL, maxSizeInBytes: self.maxSizeInBytes)

                        if isWithinLimit {
                            self.postType = .videoURL
                            self.videoUrl = videoURL
                            self.playVideo(from: videoURL, isAllowed: true)
                        } else {
                            // Compress the video
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let outputURL = documentsDirectory.appendingPathComponent("compressedVideo.mp4")
                            compressVideo(inputURL: videoURL, outputURL: outputURL) { compressedURL, error in
                                if let compressedURL = compressedURL {
                                    // Set postType to indicate it's a video
                                    self.postType = .videoURL
                                    // Play the video
                                   
                                    // Compression successful, use the compressed video URL
                                    print("Compression successful. Compressed video saved at \(compressedURL)")
                                    self.videoUrl = compressedURL
                                    if let videoURL = self.videoUrl {
                                        let isWithinLimit = self.isVideoSizeWithinLimit(videoURL: videoURL, maxSizeInBytes: self.maxSizeInBytes)

                                        if isWithinLimit {
                                            print("Video size is within the limit.")
                                            self.playVideo(from: videoURL, isAllowed: true)
                                        } else {
                                            self.playVideo(from: videoURL, isAllowed: false)
                                        }
                                    } else {
                                        print("Invalid video URL.")
                                    }
                                    
                                } else {
                                    // Compression failed
                                    print("Compression failed. ", error as Any)
                                }
                            }
                        }
                }
            }
        }
    }
    
    func isVideoSizeWithinLimit(videoURL: URL, maxSizeInBytes: Int) -> Bool {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: videoURL.path)
            if let fileSize = fileAttributes[.size] as? Int {
                // Check if the fileSize is within the limit
                return fileSize <= maxSizeInBytes
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func playVideo(from url: URL, isAllowed: Bool) {
        if isAllowed {
            DispatchQueue.main.async {
                self.videoView.isHidden = false
                self.playPauseBtn.isHidden = false
                self.buttonViewHeightConst.constant = 0
                self.primaryBtnView.isHidden = true
                self.bottomBtnView.isHidden = false
                self.bottomPhotosBtn.isHidden = true
                self.bottomDocBtn.isHidden = true
                self.bottomVideoBtn.isHidden = false
            }
            
            let playerItem = AVPlayerItem(url: url)
            myplayer = AVPlayer(playerItem: playerItem)
            let layer = AVPlayerLayer(player: myplayer)
            layer.frame = videoView.bounds
            
            layer.videoGravity = .resizeAspectFill
            DispatchQueue.main.async {
                self.hideActivity()
                self.videoView.layer.addSublayer(layer)
            }
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: myplayer?.currentItem, queue: nil) { [weak self] _ in
                // Video playback finished
                self?.myplayer?.seek(to: CMTime.zero)
                self?.myplayer?.pause()
            }
        } else {
            DispatchQueue.main.async {
                self.presentAlert("Alert", "Maximum size limit of 2MB exceeds")
            }
        }
    }
    
    // Function to get the size of a file at a given URL
    func fileSize(at url: URL) -> Int64 {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = attributes[.size] as? Int64 {
                return fileSize
            }
        } catch {
            print("Error getting file size: \(error)")
        }
        return 0
    }
}


//MARK: - Image/VideoPicker Delegate (Multiple)
extension AddPostVC: PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
//        selectedImages.removeAll()
        for result in results {
            //            self.activityIndicator.startAnimating()
            let prov = result.itemProvider
            if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                self.postType = .videoURL
                self.videoView.isHidden = false
                self.dealWithVideo(result: result)
                
            } else if prov.canLoadObject(ofClass: PHLivePhoto.self) {
                
            } else if prov.canLoadObject(ofClass: UIImage.self) {
                self.postType = .image
                
                self.dealWithImage(result: result)
            }
            
        }
        
    }
    
    @available(iOS 14.0, *)
    func dealWithVideo(result: PHPickerResult) {
        let itemProvider = result.itemProvider
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
//            if let url = url {
//                self.playVideo(from: url)
//                self.videoUrl = url
//            }
        }
    }
    
    @available(iOS 14.0, *)
    func dealWithImage(result: PHPickerResult) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            
            if let pickedImage = object as? UIImage {
                if self.postImages.count < 5 {
                    self.postImages.append(pickedImage)
                } else {
                    self.presentAlert("Alert","Image limit reached. Cannot add more than 5 images.")
                }
            }

            if let Error = error {
                print("Error....",Error)
                DispatchQueue.main.async {
                    self.presentAlert("Error", "Please select a different image.")
//                        self.showAlert(alertText: "Error", alertMessage: "Please select a different image.")
                }
            }
        }
    }
    
    func getTotalImageSize() -> Int {
        var totalSize = 0
        
        for image in postImages {
            if let data = image.jpegData(compressionQuality: 0.5) {
                totalSize += data.count
            }
        }
        
        return totalSize
    }

    func isImageSizeWithinLimit() -> Bool {
        let totalSizeInBytes = getTotalImageSize()
        print("Image size", totalSizeInBytes)
        let limitInBytes = 4 * 1024 * 1024 // 4MB in bytes
        
        return totalSizeInBytes <= limitInBytes
    }
}

extension AddPostVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPostImages.ReuseId, for: indexPath) as? NewPostImages {
            //DataBinding
          
          
            if mode == .edit {
                if selectedIndices.contains(indexPath.row)
                {
                    let index = selectedIndices.firstIndex(of: indexPath.row)
                    selectedIndex = indexPath.row
                    cell.removeBtn.isHidden = false
                    cell.removeBtn.tag = index!
                    cell.removeBtn.addTarget(self, action:#selector(removeImage(sender:)), for: .touchUpInside)
                }
                else{
                    cell.removeBtn.isHidden = true
                }

                cell.cellImage.image = postImages[indexPath.row]
                cell.cellImage.contentMode = .scaleAspectFill
            }
            else {
                
                cell.cellImage.image = postImages[indexPath.row]
                cell.removeBtn.tag = indexPath.row
                cell.removeBtn.isHidden = false
                cell.cellImage.contentMode = .scaleAspectFill
                cell.removeBtn.addTarget(self, action:#selector(removeImage(sender:)), for: .touchUpInside)
                
            }
          
           return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let inset: CGFloat = 3
//        let width = collectionView.frame.width / inset
//        let height = collectionView.frame.height
//        return CGSize(width: width, height: height)
        let width = self.collectionView.frame.size.width/3 - 10
        return CGSize(width: width, height: width)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
}
extension AddPostVC {
    
    //MARK: VideoOpening
    
    func configureVideoView(getUrl: URL?){
        if getUrl != nil {
            myplayer = AVPlayer(url: getUrl!)
            let playerLayer = AVPlayerViewController()
            playerLayer.player = myplayer
            self.present(playerLayer, animated: true, completion: {
                self.myplayer?.play()
            })
        }
    }
    
    @objc func showVideoView(sender: UIButton) {
        print("ButtonIndex\(sender.tag)")
        configureVideoView(getUrl: selectedVideoUrl)
        
    }
    
    func encodeVideoToBase64(URL: URL) -> String? {
        if FileManager.default.fileExists(atPath: URL.path) {
            // The file exists, proceed with encoding
            showActivity()
            do {
                let videoData = try Data(contentsOf: URL)
                let base64String = videoData.base64EncodedString()
                hideActivity()
                return base64String
            } catch {
                print("Error encoding video to base64: \(error)")
                hideActivity()
                return nil
            }
        } else {
            print("File does not exist at: \(URL.path)")
            return nil
        }
    }
    
//    func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (URL?) -> Void) {
//        let asset = AVAsset(url: inputURL)
//
//        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
//            completion(nil)
//            return
//        }
//
//        exportSession.outputURL = outputURL
//        exportSession.outputFileType = AVFileType.mp4
//
//        exportSession.exportAsynchronously {
//            switch exportSession.status {
//            case .completed:
//                completion(outputURL)
//            case .failed, .cancelled:
//                completion(nil)
//            default:
//                break
//            }
//        }
//    }
    
    func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        
        let asset = AVAsset(url: inputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
                let error = NSError(domain: "com.aviation.videoCompressionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "AVAssetExportSession initialization failed"])
                completion(nil, error)
                return
            }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
            
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    completion(outputURL, nil)
                case .failed, .cancelled:
                    let error = exportSession.error ?? NSError(domain: "com.aviation.videoCompressionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Compression failed"])
                    completion(nil, error)
                default:
                    break
                }
            }
    }
    
}

//MARK: Document
extension AddPostVC: UIDocumentPickerDelegate {

    private func openFile() {
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet, kUTTypeCompositeContent]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        videoUrl = nil
        videoView.isHidden = true
        playPauseBtn.isHidden = true
        self.postImages = []
        documentView.isHidden = false
        buttonViewHeightConst.constant = 0
        primaryBtnView.isHidden = true
        bottomBtnView.isHidden = false
        bottomPhotosBtn.isHidden = true
        bottomDocBtn.isHidden = false
        bottomVideoBtn.isHidden = true
        documentURL = url
        docNameLbl.text = url.lastPathComponent
        postType = .article
        
        if let fileSize = fileSize(at: url) {
            print("Document size: \(fileSize) bytes")
            docSizeLbl.text = "\(convertBytesToKilobytes(fileSize)).kb"
        } else {
            print("Unable to retrieve document size.")
        }
        
    }
    
    func convertBytesToKilobytes(_ bytes: Int64) -> String {
        let fileSizeInKilobytes = Double(bytes) / 1024.0
        return String(format: "%.2f", fileSizeInKilobytes)
    }
    
    func fileSize(at url: URL) -> Int64? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = fileAttributes[.size] as? Int64 {
                return fileSize
            } else {
                return nil
            }
        } catch {
            print("Error retrieving file size: \(error.localizedDescription)")
            return nil
        }
    }
    
//    private func openFile() {
//
//        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet,kUTTypeCompositeContent]
//
//        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
//
//        documentPicker.delegate = self
//        present(documentPicker, animated: true, completion: nil)
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//
//        let fileManager = FileManager.default
//        // Get document directory for device, this should succeed
//        let documentDirectory = fileManager.urls(for: .documentDirectory,
//                                                 in: .userDomainMask).first!
//        // Construct a URL with desired folder name
//        let folderURL = documentDirectory.appendingPathComponent("EvaDocuments")
//        // If folder URL does not exist, create it
//        if !fileManager.fileExists(atPath: folderURL.path) {
//            do {
//                try fileManager.createDirectory(atPath: folderURL.path,
//                                                withIntermediateDirectories: true,
//                                                attributes: nil)
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//
//        let savePdfUrl = folderURL.appendingPathComponent(url.lastPathComponent)
//
//        do { try FileManager.default.moveItem(at: url, to: savePdfUrl) }
//        catch {
//            print("error")
//        }
//
//        //fileNameLbl.text = url.lastPathComponent
//        cvURL = savePdfUrl
//        isArticleChange = true
//        loadArticleForPreview(article: cvURL?.absoluteString)
//        documentName.text = url.lastPathComponent
//        openArticleBtn.addTarget(self, action: #selector(openArticle), for: .touchUpInside)
//        documentView.isHidden = false
//        removeDocument.isHidden = false
//        isUrlCheck = true
//        postFileBtn.isEnabled = true
//        postFileBtn.alpha = 1
//
//    }
//    @objc func openArticle(){
//        if let urlString = cvURL?.absoluteString , let url = URL(string: urlString) {
//            let webVC = WebVC(url: url)
//            webVC.modalPresentationStyle = .formSheet
//            present(webVC, animated: true, completion: nil)
//        }
//    }
//    private func loadArticleForPreview(article: String?){
//       // let sampleImage = "http://168.63.140.202:8003/media/public/no_image.png"
//        guard let link = URL(string: article!) else {
////            let link = URL(string: sampleImage)
////            let request = URLRequest(url: link)
////            web.load(request)
//            return
//        }
//
//        let request = URLRequest(url: link)
//        web.load(request)
//    }
}

extension AddPostVC: UIWebViewDelegate{
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}

enum PostLoadingMode {
    case create
    case edit
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        var leftMargin: CGFloat = sectionInset.left
        
        var maxY: CGFloat = -1.0
        layoutAttributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return layoutAttributes
    }
}
