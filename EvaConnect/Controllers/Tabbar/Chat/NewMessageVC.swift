//
//  NewMessageVC.swift
//  EvaConnect
//
//  Created by usama on 17/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import Firebase
import Alamofire

class NewMessageVC: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var messageView: UIView!

    @IBOutlet weak var attachFilesView: UIView! {
        didSet {
            attachFilesView.backgroundColor = AppColors.evaBackground
            attachFilesView.layer.cornerRadius = 20.0
            attachFilesView.layer.borderColor = UIColor.darkGray.cgColor
            attachFilesView.layer.borderWidth = 1.0
            attachFilesView.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            
            sendButton.layer.borderColor = AppColors.border.cgColor
            sendButton.layer.borderWidth = 1.0
            sendButton.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var usersSearchTF: UITextField! {
        didSet {
            usersSearchTF.backgroundColor = AppColors.textViewBackground
        }
    }
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            messageTextView.backgroundColor = AppColors.textViewBackground
            messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    @IBOutlet weak var selectedUserView: UIView!
    @IBOutlet weak var selectedUserlabel: UILabel!
    @IBOutlet weak var selectedUserImage: UIImageView!

    
    @IBOutlet weak var usersCollectionView: UICollectionView! {
        didSet {
            usersCollectionView.delegate = self
            usersCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var mediaCollectionView: UICollectionView! {
        didSet {
            mediaCollectionView.dataSource = mediaDataSource
            mediaCollectionView.delegate = self
        }
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Properties

    let pageSize = 200
    let pageNumber = 0
    
    var inSearchMode = false
    var filteredUsers: [User] = []
    var imagePicker = UIImagePickerController()
    let mediaDataSource = NewMessageMediaDataSource()
    var selectedUser: User? {
        didSet {
            if let selectedUser = selectedUser {
                selectedUserlabel.text = selectedUser.firstName
                selectedUserImage.sd_setImage(with: URL(string: selectedUser.userImage!), completed: nil)
            }
        }
    }
    
    var dismissGesture: UITapGestureRecognizer!
    
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.usersCollectionView.reloadData()
            }
        }
    }
    
    var chosenImages: [UIImage] = [] {
        didSet {
            mediaCollectionView.reloadData()
        }
    }
    
    // MARK: UI Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        updateUsers()
        
    }
    
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchAlgorithm(searchText: textField.text)
    }
}

extension NewMessageVC {

//    @IBAction func send_touchUpInside(_ sender: UIButton) {
//        
//        if mediaDataSource.chosenImages.count  > 0 {
//             chatMediaUploadCall()
//             return
//         }
//         
//         sendMessagesToServer()
//    }
    
//    func chatMediaUploadCall() {
//
//        let parameters = [ "created_by_id": LoggedUserDetails.shared.user!.id,
//                           "status": "active" ] as [String : Any]
//
//        Alamofire.upload(multipartFormData: { (multiFormData) in
//
//            for (key, value) in parameters {
//                multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//            self.mediaDataSource.chosenImages.enumerated().forEach { (index, image) in
//                let imageData = image.jpegData(compressionQuality: 0.50)
//                multiFormData.append(imageData!, withName: "chat_file", fileName: "Chat_image\(index).jpg", mimeType: "image/png")
//            }
//
//        }, to: EndPoints.uploadMedia, headers: SharedHeaders.headers) { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    //Print progress
//                    print("uploading \(progress)")
//                })
//
//                upload.responseJSON { (response) in
//                    if response.result.isSuccess {
//                        let jsonDecoder = JSONDecoder()
//                        let chatUploadResponse = try? jsonDecoder.decode(ChatImages.self, from: response.data!)
//
//                        if let chatImages = chatUploadResponse, !chatImages.error {
//                            self.sendMessagesToServer(images: chatImages.data.images)
//                        }
//                    }
//                }
//
//            case .failure(let error):
//                print (error.localizedDescription)
//            }
//        }
//    }
    
//    func sendMessagesToServer(images: [String] = []) {
//        // create conversation for the first time
//        if let user = selectedUser, let text = messageTextView.text, text.count > 0 {
//
//            let message = Message(text: text, sender: self.currentSender(), messageId: UUID().uuidString, date: Date(), images: images)
//
//            findExistingConversation(with: user) { (conversation) in
//
//                if let conversation = conversation {
//
//                    FirebaseHandler.handler.ref.child("messages").child(conversation.id).childByAutoId().setValue(message.fbDictionary)
//                    FirebaseHandler.handler.ref.child("chats").child(conversation.id).child("lastMessage").setValue(message.fbDictionary)
//
//                    for member in conversation.memebers {
//                        FirebaseHandler.handler.ref.child("users/\(member.id)/chats/\(conversation.id)/last_update_time").setValue((Date().timeIntervalSince1970 * 1000).rounded())
//                        if Int(member.id) != LoggedUserDetails.shared.user!.id {
//                            FirebaseHandler.handler.ref.child("users/\(member.id)/chats/\(conversation.id)/unread").setValue((true))
//                        }
//                    }
//
//                    self.dismiss(animated: true, completion: nil)
//                } else {
//                    let ref = fb.handler.ref.child("chats").childByAutoId()
//                    //                        willStartNewConversation?(ref.key!)
//                    self.activityIndicator.startAnimating()
//                    ref.setValue(["members": ["\(LoggedUserDetails.shared.user!.id)" : LoggedUserDetails.shared.user!.fullName,
//                                              "\(user.id)": user.fullName],
//                                  "lastMessage": message.fbDictionary]) {[weak self ] (error, ref) in
//
//                                    self?.activityIndicator.stopAnimating()
//                    }
//
//                    fb.handler.ref.child("messages").child(ref.key!).childByAutoId().setValue(message.fbDictionary)
//
//
//                    let stamp = (Date().timeIntervalSince1970 * 1000).rounded()
//                    let myRef = fb.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id)/chats/\(ref.key!)")
//                    myRef.setValue(["last_update_time":stamp,
//                                    "unread":false])
//
//                    let otherUserRef = FirebaseHandler.handler.ref.child("users/\(user.id)/chats/\(ref.key!)")
//                    otherUserRef.setValue(["last_update_time":stamp,
//                                           "unread":true])
//                }
//
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    
}

private extension NewMessageVC {
    
    func initUI() {
        
        //        usersSearchTF.layer.borderColor = UIColor(hex: AppColors.border).cgColor
        //        usersSearchTF.layer.borderWidth = 1.0
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        usersSearchTF.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                for: .editingChanged)
        
        dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        dismissGesture.delegate = self
        view.addGestureRecognizer(dismissGesture)
        mediaCollectionView.registerNib(cellNib: MediaPickerCell.self)
        listenToMediaChanges()
        
    }
    
    func listenToMediaChanges() {

        _ = NotificationCenter.default.addObserver(forName: .refreshMediaCollection, object: nil, queue: .main) { (_) in
            self.mediaCollectionView.reloadData()
        }
    }
    
    private func updateUsers() {
         
         activityIndicator.startAnimating()
         UserDataHandler.getUsers(pageNumber: pageNumber, pageSize: pageSize) { (users, error) in
             
             self.activityIndicator.stopAnimating()
             self.activityIndicator.isHidden = true

             if let users = users {
                 self.users.append(contentsOf: users.filter({ $0.isConnected == "active" }))
             }
         }
     }
}

private extension NewMessageVC {
    func searchAlgorithm(searchText: String? = nil) {

        guard let searchText = searchText, searchText.length > 0 else {
            
            inSearchMode = false
            filteredUsers = []
            usersCollectionView.reloadData()
            return
        }
        
        filteredUsers = users.filter({ $0.firstName.lowercased().range(of: searchText) != nil })
        inSearchMode = true
        usersCollectionView.reloadData()
    }
}

extension NewMessageVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mediaCollectionView {
            return chosenImages.count
        }
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mediaCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPickerCell", for: indexPath) as? MediaPickerCell {
                
                cell.selectedPhoto.image = chosenImages[indexPath.row]
//                cell.delegate = self
                cell.removeButton.tag = indexPath.row
                return cell
            }
        } else {
            let cell: UsersCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == usersCollectionView {
            
            usersSearchTF.isUserInteractionEnabled = false
            selectedUser = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
            
            usersCollectionView.isHidden = true
            view.bringSubviewToFront(selectedUserView)
            
        }
    }
}

extension NewMessageVC: UITextFieldDelegate {
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField.text?.count > 0 {
//
//        }
//    }
}


extension NewMessageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        
        if collectionView == usersCollectionView {
            return CGSize(width: width * 0.5, height: height)
        } else {
            return CGSize(width: 51, height: 44)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == usersCollectionView { return 0 }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == usersCollectionView { return 0 }
        
        return 5
    }
}


extension NewMessageVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func attach_touchUpInside(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            mediaDataSource.chosenImages.append(image)
            mediaCollectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension NewMessageVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: messageView) == true {
            return false
        }
        return true
    }
}

//extension NewMessageVC {
//    func currentSender() -> Sender {
//        Sender(id: selectedUser?.id ?? 0, name: selectedUser?.firstName ?? "")
//    }
//}
