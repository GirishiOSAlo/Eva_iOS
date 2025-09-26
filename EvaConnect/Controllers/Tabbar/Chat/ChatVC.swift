//
//  ChatVC.swift
//  EvaConnect
//
//  Created by usama on 20/04/2020.
//  Modified by Muhammad Salman Zafar on 23/12/2021.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import FirebaseDatabase
import Alamofire
import IQKeyboardManagerSwift
import PhotosUI
import MobileCoreServices
import FirebaseDatabase

class ChatVC: BaseVC {
    
    @IBOutlet weak var blockedView: UIView!
    @IBOutlet weak var attachementBackgroundView: UIView!
    @IBOutlet weak var addBottomSheetConstraint: NSLayoutConstraint!
    enum MediaAttachmentType {
        case document, image
    }
    struct MediaAttachment {
        let fileURL: URL?
        let image: UIImage?
        let type: MediaAttachmentType
    }
    
    // MARK: IB Outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var chatMemberImage: UIImageView!
    @IBOutlet weak var chatMemberName: UILabel!
    @IBOutlet weak var lstOnlineLbl: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var attachmentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attachments: UIView!
    
    @IBOutlet weak var attachmentMainView: UIView!
    @IBOutlet weak var attachmentMainVwTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var attachmentPopupView: UIView!

    
//    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var composeMessageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageTextVwHeight: NSLayoutConstraint!
    let placeholderLabel = UILabel()
    
    @IBOutlet weak var mediaCollectionView: UICollectionView! {
        didSet {
            mediaCollectionView.dataSource = self
            mediaCollectionView.delegate = self
            mediaCollectionView.contentInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
            mediaCollectionView.backgroundColor = AppColors.evaBackground
        }
    }
    
    @IBOutlet weak var msgFeatureTopVw: UIView!
    
    @IBOutlet weak var cameraAttachmentBtn: UIButton!
    @IBOutlet weak var galleryAttachmentBtn: UIButton!
    @IBOutlet weak var documentAttachmentBtn: UIButton!
    @IBOutlet weak var audioAttachmentBtn: UIButton!
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var textViewRP: UIView!
    @IBOutlet weak var textLblRP: UILabel!
    @IBOutlet weak var imageViewRP: UIView!
    @IBOutlet weak var imageRP: UIImageView!
    @IBOutlet weak var docViewRP: UIView!
    @IBOutlet weak var DocBgImageViw: UIImageView!
    
    @IBOutlet weak var docImageRP: UIImageView!
    @IBOutlet weak var docNameRP: UILabel!
    @IBOutlet weak var docSizeRP: UILabel!
    @IBOutlet weak var DocTimeLbl: UILabel!
    @IBOutlet weak var docDLBtn: UIButton!
    
    @IBOutlet weak var audViewRP: UIView!
    @IBOutlet weak var audBGImgView: UIImageView!
    @IBOutlet weak var audImgRP: UIImageView!
    
    @IBOutlet weak var audNameRP: UILabel!
    @IBOutlet weak var audSizeRP: UILabel!
    @IBOutlet weak var audTimeLblRP: UILabel!
    @IBOutlet weak var audDLBtnRP: UIButton!
    @IBOutlet weak var attachmentBtnWidthConst: NSLayoutConstraint!
    @IBOutlet weak var closeRplyBtn: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var composeMsgHeight: NSLayoutConstraint!
    
    // MARK: Properties
    var isFeatureOpen = false
    var isReply = false
    var didSelect = false
    var isFirstTime = true
    var endOfData = false
    var lastMsgId = 0
    var msgId = ""
    var replyMsgId = 0
    var offsetCount = 1
    var titleString: String!
    var user: UserConnection?
    var deleteMsgId: [Int] = []
    var FwdMsgId: [Int] = []
    
    var chats: [ChatList] = []
    
    var conversationDetails: Conversation?
    var messages: [ChatMessage] = []
    
    var isComeFromNotification = false
    var notificationChat: FirebaseNotification?
    
    var articleContent: String?
    var tempChats : [ChatList] = []
    var userId = 0
    var isLstHit = false
    
    private var documentURL: URL? = nil
    private var audioURL: URL? = nil
    private var videoURL: URL? = nil
    var fileName: String = ""
    var postImages: [UIImage] = []
    var imageArray: [String] = []
    var postType: attachmentType = .image
    
    let textViewMaxHeight: CGFloat = 120
    var mediaAttachments: [MediaAttachment] = []
    
    
    var documentInteractionController: UIDocumentInteractionController!
    private var sendPushNotification = false
    var timer: Timer?
    var isLongPress = false
    
    
    // MARK: UI Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.messageTextView.delegate = self
        self.isSeparatorHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        //self.readAllMessages()
        tableView.allowsMultipleSelection = false
        
        // Schedule the timer to call the function every 10 seconds
//        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        //Keyboard Show Hide managed...
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func timerAction() {
        // Your function code goes here
        print("Chat Reloaded....")
//        self.chats.removeAll()
       FetchMsgList(id: user?.id ?? userId, offset: 1, autoReload: true)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        initChat()
        self.replyViewHeightConst.constant = 0
        self.attachmentBtnWidthConst.constant = 37.3
        //showActivity()
        //FetchMsgList(id: user?.id ?? userId, offset: self.offsetCount, autoReload: false)
        self.isFeatureOpen = false
        self.msgFeatureTopVw.isHidden = true
        self.fetchMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        IQKeyboardManager.shared.isEnabled = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        if let conversation = conversation { fb.handler.ref.child("messages").child(conversation.id).removeAllObservers() }
        timer?.invalidate()
        timer = nil
        IQKeyboardManager.shared.isEnabled = true
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? ((keyboardFrame!.height) - 25) : 0
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }

    
//    func initChat() {
//        isSeparatorHidden = true
//        if let conversation = conversation {
//            fb.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id)/chats/\(conversation.id)/unread").setValue(false)
//            fb.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id)/chats/\(conversation.id)/unread_count").setValue(0)
//
////            fb.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id)/chats/\(conversation.id)/messageCount").setValue(0)
////            loadFirstMessages()
//
//        }
//    }
    
    func initUI() {
        chatMemberImage.roundOnly()
        self.isFeatureOpen = false
        self.msgFeatureTopVw.isHidden = true
        
        popupView(uiView: attachmentPopupView)
        self.attachmentMainVwTopConstraints.constant = self.view.frame.size.height
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDidTap))
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(dismissTapGesture)

        self.messageTextVwHeight.constant = 35
        // Setup placeholderLabel
        self.placeholderLabel.text = "Write a reply"
        self.placeholderLabel.font = self.messageTextView.font
        self.placeholderLabel.textColor = .lightGray
        self.placeholderLabel.frame = CGRect(x: 5, y: 8, width: self.messageTextView.frame.width - 10, height: 20)
        self.messageTextView.addSubview(self.placeholderLabel)
        // Show/hide placeholder as needed
        self.placeholderLabel.isHidden = !self.messageTextView.text.isEmpty
        
//        if self.isComeFromNotification {
            let loggedInUserId = myUserDefaults.userId
            let otherUserID = userId
            let chatId = makeChatId(user1Id: loggedInUserId, user2Id: otherUserID)
            print("Notification Chat Id : \(chatId)")
            fetchUserForChat(chatId: chatId, loggedInUserId: loggedInUserId) { user in
                if let user = user {
                    print("Other user name: \(user.name ?? "N/A")")
                    self.chatMemberImage.kf.setImage(with: URL(string: user.avatar ?? ""), placeholder: UIImage(named: "profile"))
                    self.chatMemberName.text = user.name
                    self.lstOnlineLbl.text = user.status
                } else {
                    print("Notification User not found")
                }
            }
//        } else {
//            if let conversation = conversationDetails {
//                chatMemberImage.kf.setImage(with: URL(string: conversation.user?.avatar ?? ""), placeholder: UIImage(named: "profile"))
//                chatMemberName.text = conversation.user?.name
//                lstOnlineLbl.text = conversation.user?.status//DateUtils.formatTo24Hour(timestamp: conversation.lastMessage?.timestamp ?? 0.0)
//            } else {
//                print("User not found")
//            }
//        }
        
//        if let user = user {
//            if let imageName = user.userImage,
//                let url = URL(string: imageName) {
//
//                chatMemberImage.kf.setImage(with: url)
//            }
//            chatMemberName.text = user.firstName
//
//
////            findExistingConversation(with: user) { (conversation) in
////
////                if let conversation = conversation {
////
////                    self.conversation = conversation
////                    fb.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id)/chats/\(conversation.id)/unread").setValue(false)
////                    fb.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id)/chats/\(conversation.id)/unread_count").setValue(0)
//////                    self.loadFirstMessages()
////                }
////            }
//        }
        
        textViewRP.layer.cornerRadius = 13
        imageViewRP.layer.cornerRadius = 13
        docViewRP.layer.cornerRadius = 13
        audViewRP.layer.cornerRadius = 13
        
//        headerView.backgroundColor = AppColors.lightGrayBG
//        composeMessageView.backgroundColor =  AppColors.lightGrayBG
        
        attachementBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(attachementBackgroundViewTapped)))

        mediaCollectionView.registerNib(cellNib: MediaPickerCell.self)
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = false
        tableViewConfiguration()
        setSendMessageView()
        attachmentButton.layer.cornerRadius = attachmentButton.layer.bounds.width/2
        view.bringSubviewToFront(attachments)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    @objc func dismissDidTap() {
        self.attachmentMainVwTopConstraints.constant = self.view.frame.size.height
    }
    
    private func setSendMessageView() {
//        sendMessageView = SendMessgeView()
//        sendMessageView.addButton.addTarget(self, action: #selector(browseFiles_touchUpInside(_:)), for: .touchUpInside)
//        sendMessageView.sendButton.addTarget(self, action: #selector(send_touchUpInside(_:)), for: .touchUpInside)
//        sendMessageView.isUserInteractionEnabled = false
//        view.addSubview(sendMessageView)
        
//        bottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: sendMessageView.bottomAnchor)
//
//        NSLayoutConstraint.activate([
//            tableView.bottomAnchor.constraint(equalTo: sendMessageView.topAnchor),
//            view.leadingAnchor.constraint(equalTo: sendMessageView.leadingAnchor),
//            view.trailingAnchor.constraint(equalTo: sendMessageView.trailingAnchor),
//            bottomConstraint
//        ])
    }

    func tableViewConfiguration() {
        tableView.backgroundColor = AppColors.lightGrayBG
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView =  UIView()
        tableView.registerCell(withType: ReceiverCell.self)
        tableView.registerCell(withType: SenderCell.self)
        tableView.registerCell(withType: MediaTVCell.self)
        
        tableView.registerCell(withType: DocAudioTVCell.self)
        tableView.registerCell(withType: TextMsgTVCell.self)
        tableView.registerCell(withType: RecvrTextTVCell.self)
        tableView.registerCell(withType: SenderImgTVCell.self)
        tableView.registerCell(withType: ReceiverImgTVCell.self)
        tableView.registerCell(withType: ReplyTVCell.self)
        
    }
    
    @IBAction func closeReplyTapped(_ sender: UIButton) {
        self.isReply = false
        self.replyViewHeightConst.constant = 0
        self.attachmentBtnWidthConst.constant = 37.3
    }
    
    @IBAction func replyBtnTapped(_ sender: UIButton) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            let indexPath = selectedRows[0].row
            let selectedRow = indexPath
            let obj = chats[selectedRow]
            self.isReply = true
            self.replyMsgId = obj.id ?? 0
            self.attachmentBtnWidthConst.constant = 0
            switch obj.type {
            case .message:
                self.audViewRP.isHidden = true
                self.imageViewRP.isHidden = true
                self.docViewRP.isHidden = true
                self.textViewRP.isHidden = false
                self.replyViewHeightConst.constant = 150
                self.textLblRP.text = obj.message
                break
            case .doc:
                self.audViewRP.isHidden = true
                self.imageViewRP.isHidden = true
                self.docViewRP.isHidden = false
                self.textViewRP.isHidden = true
                self.replyViewHeightConst.constant = 150
                
                break
            case .image:
                self.audViewRP.isHidden = true
                self.imageViewRP.isHidden = false
                self.docViewRP.isHidden = true
                self.textViewRP.isHidden = true
                self.imageRP.sd_setImage(with: URL(string: obj.imageURL ?? ""))
                self.replyViewHeightConst.constant = 150
                break
            case .audio:
                self.audViewRP.isHidden = false
                self.imageViewRP.isHidden = true
                self.docViewRP.isHidden = true
                self.textViewRP.isHidden = true
                self.replyViewHeightConst.constant = 150
                break
            case .reply:
                break
            default:
                self.replyViewHeightConst.constant = 0
                break
            }
            
        } else {
            print("No rows selected")
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        print("Delete Message...")
//        if let selectedRows = tableView.indexPathsForSelectedRows {
//            for indexPath in selectedRows {
//                let selectedRow = indexPath.row
//                let id = Int(chats[selectedRow].id ?? 0)
//                self.deleteMsgId.append(id)
//                print("Selected Row: \(selectedRow)")
//            }
//            
//            deleteAllMessages()
//        } else {
//            print("No rows selected")
//        }
    }
    
    @IBAction func copyBtnTapped(_ sender: UIButton) {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            let indexPath = selectedRows[0].row
            let selectedRow = indexPath
            //let msg = chats[selectedRow].message ?? ""
            let msg = messages[selectedRow].message ?? ""
            UIPasteboard.general.string = msg
            print("Copied to clipboard: \(msg)")
        } else {
            print("No rows selected")
        }
    }
    
    @IBAction func forwardBtnTapped(_ sender: UIButton) {
        print("Forward Message...")
//        if let selectedRows = tableView.indexPathsForSelectedRows {
//            for indexPath in selectedRows {
//                let selectedRow = indexPath.row
//                let id = Int(chats[selectedRow].id ?? 0)
//                self.FwdMsgId.append(id)
//                print("Selected Row: \(selectedRow)")
//            }
//            
//            let vc = StoryboardRouter.forwardChatVC()
//            vc.msgIdArr = self.FwdMsgId
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            print("No rows selected")
//        }
        
        
    }
    
    //MARK: Attachment Button Action......
    @IBAction func onCameraAttachmentTap(_ sender: UIButton) {
        
    }

    @IBAction func onGalleryAttachmentTap(_ sender: UIButton) {
    }
    
    @IBAction func onDocumentAttachmentTap(_ sender: UIButton) {
    }
    
    @IBAction func onAudioAttachmentTap(_ sender: UIButton) {
    }

}

extension ChatVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .lightGray {
//            textView.text = nil
//            textView.textColor = .black
//
//        }
        //self.placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !self.messageTextView.text.isEmpty
        let lineNumber = textView.text.filter { $0 == "\n" }.count
        print("Number of new lines: \(lineNumber)")
        if lineNumber == 0 {
            self.messageTextVwHeight.constant = 35
        } else {
            self.messageTextVwHeight.constant = 51
        }
        //self.placeholderLbl.isHidden = true
        //adjustTextViewHeight()
//        if textView.contentSize.height >= self.textViewMaxHeight {
//            messageTextView.isScrollEnabled = true
//        }
//        else {
//            textView.frame.size.height = textView.contentSize.height
//            messageTextView.isScrollEnabled = false
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""//Constants.Chat.composeMessage
            textView.textColor = UIColor.lightGray
            //self.placeholderLbl.isHidden = false
        } else {
            //self.placeholderLbl.isHidden = true
        }
        
    }
    
    func adjustTextViewHeight() {
        // Set a maximum height if needed
        let maxHeight: CGFloat = 200.0
        
        // Calculate the new height based on the content size
        let newSize = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.width, height: maxHeight))
        
        // Update the text view's height constraint or frame
        messageTextView.constraints.forEach {
            if $0.firstAttribute == .height {
                // Adjust the height constraint
                $0.constant = min(newSize.height, maxHeight)
            }
        }
        
        // Optionally, scroll to the bottom to keep the latest text visible
        let bottomOffset = CGPoint(x: 0, y: max(messageTextView.contentSize.height - messageTextView.bounds.height, 0))
        messageTextView.setContentOffset(bottomOffset, animated: false)
    }
}

// MARK: API Calls
extension ChatVC {
    
    func readAllMessages() {
        
        let parameters = ["sender_id": self.userId]
        
        NetworkManagerr.request(EndPoints.readAllMessages, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if genericRoot.error == false {
                        print(genericRoot.message)
                    } else {
                        print(genericRoot.message)
                    }
                    print(genericRoot.message)
                } catch {
                    //
                }
            }
        }
    }
    
    func deleteAllMessages() {
        
        let parameters = ["message_id": self.deleteMsgId]
        
        NetworkManagerr.request(EndPoints.deleteMessage, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if genericRoot.error == false {
                        print(genericRoot.message)
                    } else {
                        print(genericRoot.message)
                    }
                    print(genericRoot.message)
                } catch {
                    //
                }
            }
        }
    }
    
    func CreateMsg(id: Int, Msg: String?, fileName: String){
        showActivity()
        var params : [String: Any] = ["receiver_id": id,
                                      "message": Msg ?? ""]
        
        
        if isReply {
            params["reply_message_id"] = self.replyMsgId
        } else {
            
            switch postType {
            case .image :
                if self.postImages.count > 0 {
                    self.postImages.enumerated().forEach { (index, mediaImage) in
//                        if let imageData = mediaImage.jpegData(compressionQuality: 0.20) {
//                            let base64ImageString = imageData.base64EncodedString(options: [])
//                            self.imageArray.append("data:image/png;base64,\(base64ImageString)")
//                        }
                        if let compressedData = compressImageToMax5MB(mediaImage) {
                            let base64 = compressedData.base64EncodedString()
                            self.imageArray.append("data:image/jpeg;base64,\(base64)")
                        }
                    }
                }
                params["image"] = self.imageArray
                break
            case .camera:
                if self.postImages.count > 0 {
                    self.postImages.enumerated().forEach { (index, mediaImage) in
//                        if let imageData = mediaImage.jpegData(compressionQuality: 0.20) {
//                            let base64ImageString = imageData.base64EncodedString(options: [])
//                            self.imageArray.append("data:image/png;base64,\(base64ImageString)")
//                        }
                        if let compressedData = compressImageToMax5MB(mediaImage) {
                            let base64 = compressedData.base64EncodedString()
                            self.imageArray.append("data:image/jpeg;base64,\(base64)")
                        }
                    }
                }
                params["image"] = self.imageArray
                break
            case .audio:
                if audioURL != nil {
//                    if let myAudUrl = audioURL {
//                        let base64Doc = encodeToBase64(reqURL: myAudUrl)
//                        params["audio"] = "data:application/mp3;base64,\(base64Doc ?? "")"
//                        params["audio_file_name"] = fileName
//                    }
                    if let audioURL = audioURL {
                        let sizeMB = fileSizeInMB(url: audioURL)
                        if sizeMB > 5 {
                            compressAudio(inputURL: audioURL) { compressedURL in
                                if let url = compressedURL, self.fileSizeInMB(url: url) <= 5 {
                                    let base64Doc = self.encodeToBase64(reqURL: url)
                                    params["audio"] = "data:audio/m4a;base64,\(base64Doc ?? "")"
                                    params["audio_file_name"] = self.fileName
                                } else {
                                    print("❌ Audio too large after compression")
                                    self.presentAlert("File Too Large", "Your audio is \(String(format: "%.2f", sizeMB)) MB. Maximum allowed size is 5 MB.")
                                }
                            }
                        } else {
                            let base64Doc = self.encodeToBase64(reqURL: audioURL)
                            params["audio"] = "data:audio/mp3;base64,\(base64Doc ?? "")"
                            params["audio_file_name"] = fileName
                        }
                    }
                }
                break
            case .video:
//                if let myVideoUrl = videoURL {
//                    let base64Video = encodeVideoToBase64(videoURL: myVideoUrl)
//                    params["post_video"] = "data:application/mp4;base64,\(base64Video ?? "")"
//                }
                if let videoURL = videoURL {
                    let sizeMB = fileSizeInMB(url: videoURL)
                    if sizeMB > 5 {
                        compressVideo(inputURL: videoURL) { compressedURL in
                            if let url = compressedURL, self.fileSizeInMB(url: url) <= 5 {
                                let base64 = self.encodeVideoToBase64(videoURL: url)
                                params["post_video"] = "data:video/mp4;base64,\(base64 ?? "")"
                            } else {
                                print("❌ Video too large after compression")
                                self.presentAlert("File Too Large", "Your video is \(String(format: "%.2f", sizeMB)) MB. Maximum allowed size is 5 MB.")
                            }
                        }
                    } else {
                        let base64 = encodeVideoToBase64(videoURL: videoURL)
                        params["post_video"] = "data:video/mp4;base64,\(base64 ?? "")"
                    }
                }
                break
            case .doc:
                if documentURL != nil {
//                    if let myDocUrl = documentURL {
//                        let base64Doc = encodeToBase64(reqURL: myDocUrl)
//                        params["document"] = "data:application/pdf;base64,\(base64Doc ?? "")"
//                        params["document_name"] = fileName
//                    }
                    if let docURL = documentURL {
                        let sizeMB = fileSizeInMB(url: docURL)
                        if sizeMB > 5 {
                            print("❌ Document is larger than 5MB")
                            self.presentAlert("File Too Large", "Your document is \(String(format: "%.2f", sizeMB)) MB. Maximum allowed size is 5 MB.")
                        } else {
                            let base64Doc = encodeToBase64(reqURL: docURL)
                            params["document"] = "data:application/pdf;base64,\(base64Doc ?? "")"
                            params["document_name"] = fileName
                        }
                    }
                }
                break
            }
        }
        
        
        
        let url = EndPoints.createMsg
        NetworkManagerr.request(url, method: .post, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let meetingRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if (meetingRoot.error == false) {
                    self.resetMSGfields()
                    //self.showActivity()
                    //self.FetchMsgList(id: self.user?.id ?? self.userId, offset: 1, autoReload: false)
                    print("msg sent")
                } else {
                    self.presentAlert("Failure", meetingRoot.message, nil)
                }
            } catch {
                print("Error: ",error)
            }
        }
    }
    
    func resetMSGfields(){
        self.imageArray = []
        self.postImages = []
        self.documentURL = nil
        self.audioURL = nil
        self.messageTextView.text = ""
//        self.placeholderLbl.isHidden = false
        self.offsetCount = 1
        self.chats.removeAll()
        self.replyViewHeightConst.constant = 0
        self.attachmentBtnWidthConst.constant = 37.3
        self.isReply = false
        self.isFeatureOpen = false
        self.msgFeatureTopVw.isHidden = true
    }
    
    func FetchMsgList(id: Int, offset: Int, autoReload: Bool) {
        //        showActivity()
        let params : [String: Any] = ["receiver_id": id,
                                      "limit": 10]
        
        //let url = EndPoints.chatList
        let url = "\(EndPoints.chatList)?offset=\(offset)"
        
        NetworkManagerr.request(url, method: .post, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let msgRoot = try jsonDecoder.decode(ChatListDataModel.self, from: response.data!)
                
                
                if !(msgRoot.error ?? false) {
                    self.tempChats.removeAll()
//                    let newMsgId = msgRoot.data?[0].chatList?.first?.id ?? 0
                    self.tempChats = msgRoot.data?[0].chatList ?? []
                    let obj = msgRoot.data?[0].userDetails
                    if obj?.blockedStatus == "blocked" {
                        self.timer?.invalidate()
                        self.timer = nil
                        self.chatMemberName.text = "User"
                        self.chatMemberImage.image = UIImage(named: "profile")
                        self.lstOnlineLbl.text = "unknown"
                        self.composeMsgHeight.constant = 0
                        self.attachmentButton.isHidden = true
                        self.tempChats = self.tempChats.reversed()
                        if self.tempChats.count > 0 {
                            
                            DispatchQueue.main.async {
                                if self.chats.count > 9 {
                                    self.tempChats.append(contentsOf: self.chats)
                                    self.chats = self.tempChats
                                    self.tableView.reloadData()
                                    self.scrollToBottom(atRow: 10, animated: false)
                                } else {
                                    self.chats = self.tempChats
                                    self.tableView.reloadData()
                                    self.scrollToBottom(atRow: self.chats.count - 1, animated: false)
                                }
                            }
                            if self.tempChats.count < 10 {
                                print("End of data 1.")
                                self.endOfData = true
                                self.offsetCount = 1
                            }
                        } else {
                            print("End of data 2.")
                            self.endOfData = true
                            self.offsetCount = 1
                        }
                    } else {
                        self.chatMemberName.text = obj?.firstName ?? ""
                        self.chatMemberImage.sd_setImage(with: URL(string: obj?.userImage ?? ""))
                        if obj?.loginStatus == "Online" {
                            self.lstOnlineLbl.text = "Online"
                        } else {
                            self.lstOnlineLbl.text = obj?.lastOnline
                        }
                        self.composeMsgHeight.constant = 100
                        self.attachmentButton.isHidden = false
                        self.tempChats = self.tempChats.reversed()
                        if self.tempChats.count > 0 {
                            DispatchQueue.main.async {
                                if self.chats.count > 9 {
                                    print("LastMsgID, \(self.lastMsgId)")
                                    print("LastTempID, \(self.tempChats.last?.id ?? 0)")
                                    if autoReload == false {
                                        self.tempChats.append(contentsOf: self.chats)
                                        self.chats = self.tempChats
                                        let currentContentOffset = self.tableView.contentOffset
                                        self.tableView.reloadData()
                                        
                                        // Set the content offset back to maintain the position
                                        self.tableView.layoutIfNeeded() // Ensures that the table view has finished laying out its cells
                                        self.tableView.setContentOffset(currentContentOffset, animated: false)
                                        if self.offsetCount == 1 && self.lastMsgId != self.chats.last?.id {
                                            self.scrollToBottom(atRow: self.chats.count - 1, animated: false)
                                        }
                                    } else {
                                        
                                        if self.isFirstTime {
                                            self.isFirstTime = false
                                            self.lastMsgId = self.chats.last?.id ?? 0
                                            self.scrollToBottom(atRow: self.chats.count - 1, animated: false)
                                        }
                                        
                                        if self.offsetCount == 1 && self.lastMsgId != self.tempChats.last?.id {
                                            self.chats.removeAll()
                                            self.endOfData = false
                                            self.chats = self.tempChats
                                            self.tableView.reloadData()
                                            self.lastMsgId = self.chats.last?.id ?? 0
                                            self.scrollToBottom(atRow: self.chats.count - 1, animated: false)
                                            
                                            self.showToast(message: "New Message")
                                        }
                                    }
                                } else {
//                                    if autoReload == false {
                                        self.chats = self.tempChats
    //                                    let currentContentOffset = self.tableView.contentOffset
                                        self.tableView.reloadData()

                                        if self.isFirstTime {
                                            self.isFirstTime = false
                                            self.lastMsgId = self.chats.last?.id ?? 0
                                            self.scrollToBottom(atRow: self.chats.count - 1, animated: false)
                                        }
                                        
                                        if self.offsetCount == 1 && self.lastMsgId != self.chats.last?.id {
                                            self.lastMsgId = self.chats.last?.id ?? 0
                                            self.scrollToBottom(atRow: self.chats.count - 1, animated: false)
                                        }
                                }
                            }
                            if self.tempChats.count < 10 {
                                print("End of data 1.")
                                self.endOfData = true
                                self.offsetCount = 1
                            }
                        } else {
                            print("End of data 2.")
                            print("Error : ",msgRoot.message ?? "")
                            self.endOfData = true
                            self.offsetCount = 1
                        }
                    }
                } else {
                    self.presentAlert("Failure", msgRoot.message, nil)
                }
            } catch {
                print("Error: ",error)
            }
        }
    }
}

// MARK: Firebase Chat Observers
extension ChatVC {
    
    func fetchMessages() {
        let loggedInUserId = myUserDefaults.userId
        let otherUserID = userId
        let chatId = makeChatId(user1Id: loggedInUserId, user2Id: otherUserID)
        print("Chat Id : \(chatId)")
        
        // ✅ messages list updated
        observeMessages(chatId: chatId) { [weak self] msgs in
            DispatchQueue.main.async {
                self?.messages = msgs.sorted(by: { $0.timestamp ?? 0.0 < $1.timestamp ?? 0.0 })
                self?.tableView.reloadData()
                // Auto scroll to bottom
                if let count = self?.messages.count, count > 0 {
                    let indexPath = IndexPath(row: count - 1, section: 0)
                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        } onError: { error in
            print("Error loading messages: \(error.localizedDescription)")
        }
    }
    
    func makeChatId(user1Id: Int, user2Id: Int) -> String {
        if user1Id < user2Id {
            return "\(user1Id)_\(user2Id)"
        } else {
            return "\(user2Id)_\(user1Id)"
        }
    }

    func observeMessages(chatId: String,
                         onUpdate: @escaping ([ChatMessage]) -> Void,
                         onError: @escaping (Error) -> Void) {
        
        let messagesRef = Database.database().reference().child("messages").child(chatId)
        
        messagesRef.observe(.value, with: { snapshot in
            var messages: [ChatMessage] = []
            
            for case let child as DataSnapshot in snapshot.children {
                if let dict = child.value as? [String: Any] {
                    
                    let message = ChatMessage(
                        audio_file: dict["audio_file"] as? String,
                        audio_file_url: dict["audio_file_url"] as? String,
                        chat_time: dict["chat_time"] as? String,
                        document: dict["document"] as? String,
                        document_url: dict["document_url"] as? String,
                        firebase_receiver_id: dict["firebase_receiver_id"] as? String,
                        firebase_sender_id: dict["firebase_sender_id"] as? String,
                        image: dict["image"] as? String,
                        image_url: dict["image_url"] as? String,
                        message: dict["message"] as? String,
                        read: dict["read"] as? Bool,
                        receiver_id: dict["receiver_id"] as? Int,
                        sender_id: dict["sender_id"] as? Int,
                        timestamp: dict["timestamp"] as? Double
                    )
                    
                    messages.append(message)
                }
            }
            
            // ✅ Sort messages chronologically by timestamp
            let sorted = messages.sorted { ($0.timestamp ?? 0) < ($1.timestamp ?? 0) }
            onUpdate(sorted)
            
        }, withCancel: { error in
            onError(error)
        })
    }

    
    func scrollToBottom(atRow: Int, animated: Bool) {
//        if !messages.isEmpty {
            let lastIndex = IndexPath(row: atRow, section: 0)
            tableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
//        }
    }

    
    //Fetch User Details by User ID from Firebase...
    func fetchUserForChat(chatId: String, loggedInUserId: Int, onComplete: @escaping (FirebaseUser?) -> Void) {
        let usersRef = Database.database().reference().child("users")
        
        // Example chatId: "10_23"
        let participants = chatId.split(separator: "_").compactMap { Int($0) }
        guard participants.count == 2 else {
            onComplete(nil)
            return
        }
        
        // Find the other participant
        let otherUserId = participants.first { $0 != loggedInUserId } ?? -1
        guard otherUserId != -1 else {
            onComplete(nil)
            return
        }
        
        // Fetch the static user details
        usersRef
            .queryOrdered(byChild: "user_id")
            .queryEqual(toValue: Double(otherUserId)) // Firebase numeric fields stored as Double
            .observeSingleEvent(of: .value) { snapshot in
                for case let child as DataSnapshot in snapshot.children {
                    if let dict = child.value as? [String: Any] {
                        let user = FirebaseUser(
                            avatar: dict["avatar"] as? String,
                            created_at: dict["created_at"] as? String,
                            email: dict["email"] as? String,
                            last_changed: dict["last_changed"] as? Double,
                            name: dict["name"] as? String,
                            status: dict["status"] as? String,
                            user_id: dict["user_id"] as? Int
                        )
                        onComplete(user)
                        return
                    }
                }
                onComplete(nil) // no user found
            }
    }

}

// MARK: Picker Methods
extension ChatVC {
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
    
//    @available(iOS 14, *)
//    func selectCamera(){
//        
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 5
//        config.filter = .images
//
//        let phPickerVC = PHPickerViewController(configuration: config)
//        phPickerVC.delegate = self
//        DispatchQueue.main.async {
//            self.present(phPickerVC, animated: true)
//        }
//    }
    
    func addPicker() -> UIImagePickerController {
       
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
    
    func encodeToBase64(reqURL: URL) -> String? {
        showActivity()
        if FileManager.default.fileExists(atPath: reqURL.path) {
            // The file exists, proceed with encoding
            do {
                let myData = try Data(contentsOf: reqURL)
                let base64String = myData.base64EncodedString()
                return base64String
            } catch {
                print("Error encoding video to base64: \(error)")
                return nil
            }
        } else {
            print("File does not exist at: \(reqURL.path)")
            return nil
        }
    }
    
    func encodeVideoToBase64(videoURL: URL) -> String? {
        if FileManager.default.fileExists(atPath: videoURL.path) {
            // The file exists, proceed with encoding
            do {
                let videoData = try Data(contentsOf: videoURL)
                let base64String = videoData.base64EncodedString()
                return base64String
            } catch {
                print("Error encoding video to base64: \(error)")
                return nil
            }
        } else {
            print("File does not exist at: \(videoURL.path)")
            return nil
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: inputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            completion(nil)
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(outputURL)
            case .failed, .cancelled:
                completion(nil)
            default:
                break
            }
        }
    }
    
}

// MARK: IB Actions
extension ChatVC {
    
    @IBAction func documents_touchUpInside(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        hideUnHideAttachementBottomSheet()
    }
    
    @IBAction func camera_touchUpInside(_ sender: UIButton) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//            present(imagePicker, animated: true, completion: nil)
//
//        }
        openCamera()
        hideUnHideAttachementBottomSheet()
    }
    
    @IBAction func pictures_touchUpInside(_ sender: UIButton) {
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
//        hideUnHideAttachementBottomSheet()
    }
    
    @IBAction func send_touchUpInside(_ sender: UIButton) {
        
//        sendButton.isUserInteractionEnabled = false
//        if mediaAttachments.count > 0 {
//            chatMediaUploadCall()
//            return
//        }
        
        if messageTextView.text.isEmpty && self.imageArray.isEmpty && self.documentURL == nil && self.audioURL == nil { return }
        
//            sendMessageView.textView.textColor == #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) { return }
        
//        sendMessageToServer()
        CreateMsg(id: user?.id ?? userId , Msg: messageTextView.text, fileName: self.fileName)
    }
    
    @IBAction func attachmentButtonTapped(_ sender: UIButton) {
//        if !mediaCollectionView.isHidden { mediaCollectionView.isHidden = true }
//        hideUnHideAttachementBottomSheet()
//        view.endEditing(true)
        //self.attachmentMainVwTopConstraints.constant = self.view.frame.size.height
        let vc = AttachmentPopupVC.instantiate()
        vc.completion = { type in
            self.postType = type
            switch type {
            case .camera:
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            let imagePicker = UIImagePickerController()
                            imagePicker.delegate = self
                            imagePicker.sourceType = .camera
                            imagePicker.allowsEditing = false
                            
                        self.present(imagePicker, animated: true, completion: nil)
                        } else {
                            print("Camera is not available.")
                        }
                break
            case .image:
                if #available(iOS 14, *) {
                    self.selectMultiple()
                } else {
                    // Fallback on earlier versions
                    self.addNewPicture()
                }
                break
            case .doc:
//                let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
//                documentPicker.delegate = self
//                self.present(documentPicker, animated: true, completion: nil)
                self.showDocumentPicker()
                break
            case .video:
                break
            case .audio:
                let pickerController = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
                pickerController.delegate = self
                pickerController.modalPresentationStyle = .fullScreen
                self.present(pickerController, animated: true, completion: nil)
                break
            }
        }
        self.navigationController?.present(vc, animated: true)
//        self.attachmentMainVwTopConstraints.constant = 0
    }
    
    private func hideUnHideAttachementBottomSheet() {
        let isHidden = addBottomSheetConstraint.constant == -300
        tabBarController?.tabBar.isHidden = isHidden
        if isHidden {
            attachments.isHidden = false
            attachementBackgroundView.isHidden = false
            attachementBackgroundView.alpha = 0
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            self.addBottomSheetConstraint.constant = isHidden ? -80 : -300
            self.attachementBackgroundView.alpha = isHidden ? 1 : 0
            self.attachementBackgroundView.layer.zPosition = 3
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
        
        animator.addCompletion { _ in
            if !isHidden { self.attachementBackgroundView.isHidden = true }
        }
    }
    
    @objc private func attachementBackgroundViewTapped() { hideUnHideAttachementBottomSheet() }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        if self.isFeatureOpen {
            self.isFeatureOpen = false
            self.msgFeatureTopVw.isHidden = true
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func SendImgDidTap(_ Sender: UIButton){
        //let obj = chats[Sender.tag]
        let obj = messages[Sender.tag]
        if obj.image_url != "" {
            let imgString = obj.image_url ?? ""
            let vc = DownloadChatImgVC.instantiate(imageString: imgString)
            vc.completion = {
                self.showToast(message: "Image Saved!!")
            }
            self.navigationController?.present(vc, animated: true)
            print("Selected:", obj.image ?? "")
        }
    }
    
    @objc func RcvImgDidTap(_ Sender: UIButton){
        //let obj = chats[Sender.tag]
        let obj = messages[Sender.tag]
        if obj.image_url != "" {
            let imgString = obj.image_url ?? ""
            let vc = DownloadChatImgVC.instantiate(imageString: imgString)
            vc.completion = {
                self.showToast(message: "Image Saved!!")
            }
            self.navigationController?.present(vc, animated: true)
            print("Selected:", obj.image ?? "")
        }
    }
    
    @objc func AudioMsgDidTap(_ Sender: UIButton){
//        let obj = chats[Sender.tag]
//        if obj.audioFileURL != nil {
//            articleContent = obj.audioFileURL
//            openArticle()
//        }
        let obj = messages[Sender.tag]
        if obj.audio_file_url != nil {
            articleContent = obj.audio_file_url
            openArticle()
        }
    }
    
    @objc func DocMsgDidTap(_ Sender: UIButton){
//        let obj = chats[Sender.tag]
//        if obj.documentURL != nil {
//            articleContent = obj.documentURL
//            openArticle()
//        }
        let obj = messages[Sender.tag]
        if obj.document_url != nil {
            articleContent = obj.document_url
            openArticle()
        }
    }
    
//    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
//        if gestureRecognizer.state == .began {
//            // Get the cell from the gesture recognizer
//            guard let cell = gestureRecognizer.view as? UITableViewCell else { return }
//
//            // Get the index path of the cell
//            guard let indexPath = tableView.indexPath(for: cell) else { return }
//
//            // Toggle the selection state of the cell
//            if tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false {
//                tableView.deselectRow(at: indexPath, animated: true)
//            } else {
//                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//            }
//        }
//    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let indexPath = tableView.indexPathForRow(at: gestureRecognizer.location(in: tableView)) else {
            return
        }

        switch gestureRecognizer.state {
        case .began:
            isLongPress = true
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            Constants.generateSelectionFeedback()
            self.isFeatureOpen = true
            self.msgFeatureTopVw.isHidden = false
        case .changed:
            // Handle any additional changes during the long press (optional)
            break
        case .ended, .cancelled:
            isLongPress = false
//            self.isFeatureOpen = false
//            self.msgFeatureTopVw.isHidden = true
        default:
            break
        }
    }
    
}

extension ChatVC : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ChatVC: PHPickerViewControllerDelegate {
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
//        selectedImages.removeAll()
        for result in results {
            //            self.activityIndicator.startAnimating()
            let prov = result.itemProvider
            if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
//                self = .videoURL
//                self.videoView.isHidden = false
//                self.dealWithVideo(result: result)
            } else if prov.canLoadObject(ofClass: PHLivePhoto.self) {
                
            } else if prov.canLoadObject(ofClass: UIImage.self) {
//                self.postType = .image
                
                self.dealWithImage(result: result)
            }
            
        }
        
    }
    
    @available(iOS 14.0, *)
    func dealWithVideo(result: PHPickerResult) {
        let itemProvider = result.itemProvider
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
            if let url = url {
//                self.playVideo(from: url)
//                self.videoUrl = url
            }
        }
    }
    
    @available(iOS 14.0, *)
    func dealWithImage(result: PHPickerResult) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            
            if let pickedImage = object as? UIImage {
                self.postImages.append(pickedImage)
                if self.messageTextView.text == "" && self.postImages.isEmpty && self.documentURL == nil && self.audioURL == nil { return }
                self.CreateMsg(id: self.user?.id ?? self.userId , Msg: self.messageTextView.text, fileName: self.fileName)
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
    
}

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //chats.count
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let msg = messages[indexPath.row]
        if msg.image != "" { //Image
            if msg.sender_id == myUserDefaults.userId {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SenderImgTVCell.id(), for: indexPath) as? SenderImgTVCell {
                    cell.selectionStyle = .default
                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                    longPressGesture.delegate = self  // Set the delegate
                    cell.addGestureRecognizer(longPressGesture)
                    cell.singleImgUIView.backgroundColor = AppColors.appBlue.withAlphaComponent(0.1)
                    cell.multiImgView.isHidden = true
                    cell.singleImgUIView.isHidden = false
                    cell.mainImageView.kf.setImage(with: URL(string: msg.image_url ?? ""), placeholder: UIImage(named: "noPhoto"))
                    cell.singleTimeLabel.text = DateUtils.formatTo24Hour(timestamp: msg.timestamp ?? 0.0)
                    cell.showDetailsBtn.tag = indexPath.row
                    cell.showDetailsBtn.addTarget(self, action: #selector(SendImgDidTap(_:)), for: .touchUpInside)
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverImgTVCell.id(), for: indexPath) as? ReceiverImgTVCell {
                    cell.selectionStyle = .default
                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                    longPressGesture.delegate = self  // Set the delegate
                    cell.addGestureRecognizer(longPressGesture)
                    cell.multiImgView.isHidden = true
                    cell.singleImgUIView.isHidden = false
                    cell.singleImgUIView.backgroundColor = .white
                    cell.mainImageView.kf.setImage(with: URL(string: msg.image_url ?? ""), placeholder: UIImage(named: "noPhoto"))
                    cell.singleTimeLabel.text = DateUtils.formatTo24Hour(timestamp: msg.timestamp ?? 0.0)
                    cell.showDetailsBtn.tag = indexPath.row
                    cell.showDetailsBtn.addTarget(self, action: #selector(RcvImgDidTap(_:)), for: .touchUpInside)
                    return cell
                }
            }
        }
        else if msg.document != "" { //Document
            if let cell = tableView.dequeueReusableCell(withIdentifier: DocAudioTVCell.id(), for: indexPath) as? DocAudioTVCell {
                cell.selectionStyle = .default
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                longPressGesture.delegate = self  // Set the delegate
                cell.addGestureRecognizer(longPressGesture)
                if msg.document != nil {
                    if msg.sender_id == myUserDefaults.userId {
                        cell.mainBaseView.backgroundColor = AppColors.appBlue.withAlphaComponent(0.1)
                        cell.mainBaseViewLeading.constant = 70.0
                        cell.mainBaseViewTralling.constant = 20.0
                    } else {
                        cell.mainBaseView.backgroundColor = .white
                        cell.mainBaseViewLeading.constant = 20.0
                        cell.mainBaseViewTralling.constant = 70.0
                    }
                    
                    cell.audioMainView.isHidden = true
                    cell.documentStackVw.isHidden = false
                    cell.docNameLbl.text = msg.document
                    cell.docSizeLbl.text = "0 KB"
                    cell.timeLabel.text = DateUtils.formatTo24Hour(timestamp: msg.timestamp ?? 0.0)
                    cell.imgVw.image = UIImage(named: "document")
                    cell.dowmloadBtn.tag = indexPath.row
                    cell.showDeatilsBtn.tag = indexPath.row
                    cell.showDeatilsBtn.addTarget(self, action: #selector(DocMsgDidTap(_:)), for: .touchUpInside)
                    cell.dowmloadBtn.addTarget(self, action: #selector(downloadDocTapped(_:)), for: .touchUpInside)
                }
                return cell
            }
        }
        else if msg.audio_file != "" { //Audio
            if let cell = tableView.dequeueReusableCell(withIdentifier: DocAudioTVCell.id(), for: indexPath) as? DocAudioTVCell {
                cell.selectionStyle = .default
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                longPressGesture.delegate = self  // Set the delegate
                cell.addGestureRecognizer(longPressGesture)
                if msg.document != nil {
                    if msg.sender_id == myUserDefaults.userId {
                        cell.mainBaseView.backgroundColor = AppColors.appBlue.withAlphaComponent(0.1)
                        cell.mainBaseViewLeading.constant = 70.0
                        cell.mainBaseViewTralling.constant = 20.0
                    } else {
                        cell.mainBaseView.backgroundColor = .white
                        cell.mainBaseViewLeading.constant = 20.0
                        cell.mainBaseViewTralling.constant = 70.0
                    }
                    
                    cell.audioMainView.isHidden = false
                    cell.documentStackVw.isHidden = true
                    cell.docNameLbl.text = msg.audio_file
                    cell.docSizeLbl.text = "0 KB"
                    cell.timeLabel.text = DateUtils.formatTo24Hour(timestamp: msg.timestamp ?? 0.0)
                    cell.imgVw.image = UIImage(named: "ic_chatAudio")
                    cell.dowmloadBtn.tag = indexPath.row
                    cell.showDeatilsBtn.tag = indexPath.row
                    cell.showDeatilsBtn.addTarget(self, action: #selector(AudioMsgDidTap(_:)), for: .touchUpInside)
                    cell.dowmloadBtn.addTarget(self, action: #selector(downloadAudioTapped(_:)), for: .touchUpInside)
                }
                return cell
            }
        }
        else if msg.message != "" { //Text
            if msg.sender_id == myUserDefaults.userId {
                if let cell = tableView.dequeueReusableCell(withIdentifier: TextMsgTVCell.id(), for: indexPath) as? TextMsgTVCell {
                    cell.selectionStyle = .default
                    // Add long press gesture recognizer to the cell
                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                    longPressGesture.delegate = self  // Set the delegate
                    cell.addGestureRecognizer(longPressGesture)
                    cell.setData(obj: msg, screenWidth: self.view.frame.size.width - 100)
                    
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: RecvrTextTVCell.id(), for: indexPath) as? RecvrTextTVCell {
                    cell.selectionStyle = .default
                    // Add long press gesture recognizer to the cell
                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                    longPressGesture.delegate = self  // Set the delegate
                    cell.addGestureRecognizer(longPressGesture)
                    cell.setData(obj: msg, screenWidth: self.view.frame.size.width - 100)
                    
                    return cell
                }
            }
        }
    
        
//        if chats.count > 0 {
//            let chat = chats[indexPath.row]
//            if chat.type == .message {
//                //MARK: Text Message Cell...
//                if (chat.senderID) ==  myUserDefaults.userId //LoggedUserDetails.shared.user?.id
//                {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: TextMsgTVCell.id(), for: indexPath) as? TextMsgTVCell {
//                        cell.selectionStyle = .default
//                        // Add long press gesture recognizer to the cell
//                        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                        longPressGesture.delegate = self  // Set the delegate
//                        cell.addGestureRecognizer(longPressGesture)
//                        cell.messageLbl.text = chat.message
//                        cell.timeLabel.text = chat.chatTime
////                        cell.mainBaseViewWidth.constant = 0
////                        cell.configure(with: chat.message ?? "")
//                        
//                        var rect: CGRect = cell.messageLbl.frame //get frame of label
//                        rect.size = (cell.messageLbl.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: cell.messageLbl.font.fontName , size: cell.messageLbl.font.pointSize)!]))! //Calculate as per label font
//                        var width = rect.width // set width to Constraint outlet
//                        print("Width of", width)
////                        cell.mainBaseViewWidth.constant = width + 20 + 32
//                        print("Actual screenWidth: ",self.view.frame.size.width)
//                        let screenWidth = self.view.frame.size.width - 52
//                        if width >= screenWidth {
//                            cell.mainBaseViewWidth.constant = screenWidth - 50
//                            print("case 1")
//                        }
//                        else if width <= 54.0 {
//                            width = width + 54.0
//                            cell.mainBaseViewWidth.constant = width //+ 35.0
//                            print("case 2")
//                        }
//                        else {
//                            cell.mainBaseViewWidth.constant = width //+ 35.0
//                            print("case 3")
//                        }
//                        return cell
//                    }
//                } else {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: RecvrTextTVCell.id(), for: indexPath) as? RecvrTextTVCell {
//                        cell.selectionStyle = .default
//                        // Add long press gesture recognizer to the cell
//                        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                        longPressGesture.delegate = self  // Set the delegate
//                        cell.addGestureRecognizer(longPressGesture)
//                        cell.recvrMsgLbl.text = chat.message
//                        cell.recvrTimeLbl.text = chat.chatTime
////                        cell.recvrMsgWidthConst.constant = 0
////                        cell.configure(with: chat.message ?? "")
//                        
//                        var rect: CGRect = cell.recvrMsgLbl.frame //get frame of label
//                        rect.size = (cell.recvrMsgLbl.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: cell.recvrMsgLbl.font.fontName , size: cell.recvrMsgLbl.font.pointSize)!]))! //Calculate as per label font
//                        var width = rect.width // set width to Constraint outlet
//                        print("Width of", width)
////                        cell.mainBaseViewWidth.constant = width + 20 + 32
//                        let screenWidth = self.view.frame.size.width - 52
//                        if width >= screenWidth {
//                            cell.recvrMsgWidthConst.constant = screenWidth - 50
//                        }
//                        else if width <= 54.0 {
//                            width = width + 54.0
//                            cell.recvrMsgWidthConst.constant = width // + 35.0
//                        }
//                        else {
//                            cell.recvrMsgWidthConst.constant = width + 35.0
//                        }
//                        return cell
//                    }
//                }
//                
//            } else if chat.type == .image {
//                // MARK: Image - Send Image Cell...
//                if (chat.senderID) ==  myUserDefaults.userId //LoggedUserDetails.shared.user?.id
//                {
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: SenderImgTVCell.id(), for: indexPath) as? SenderImgTVCell {
//                        cell.selectionStyle = .default
//                        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                        longPressGesture.delegate = self  // Set the delegate
//                        cell.addGestureRecognizer(longPressGesture)
//                        cell.singleImgUIView.backgroundColor = AppColors.appBlue.withAlphaComponent(0.1)
//                        cell.multiImgView.isHidden = true
//                        cell.singleImgUIView.isHidden = false
//                        cell.mainImageView.sd_setImage(with: URL(string: chat.imageURL ?? ""))
//                        cell.singleTimeLabel.text = chat.chatTime
//                        cell.showDetailsBtn.tag = indexPath.row
//                        cell.showDetailsBtn.addTarget(self, action: #selector(SendImgDidTap(_:)), for: .touchUpInside)
//                        return cell
//                    }
//                } else {
//                    // MARK: Image - Receive Image Cell...
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverImgTVCell.id(), for: indexPath) as? ReceiverImgTVCell {
//                        cell.selectionStyle = .default
//                        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                        longPressGesture.delegate = self  // Set the delegate
//                        cell.addGestureRecognizer(longPressGesture)
//                        cell.multiImgView.isHidden = true
//                        cell.singleImgUIView.isHidden = false
//                        cell.singleImgUIView.backgroundColor = .white
//                        cell.mainImageView.sd_setImage(with: URL(string: chat.imageURL ?? ""))
//                        cell.singleTimeLabel.text = chat.chatTime
//                        cell.showDetailsBtn.tag = indexPath.row
//                        cell.showDetailsBtn.addTarget(self, action: #selector(RcvImgDidTap(_:)), for: .touchUpInside)
//                        return cell
//                    }
//                }
//            } else if chat.type == .audio {
//                //MARK: Audio - Document Cell...
//                if let cell = tableView.dequeueReusableCell(withIdentifier: DocAudioTVCell.id(), for: indexPath) as? DocAudioTVCell {
//                    cell.selectionStyle = .default
//                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                    longPressGesture.delegate = self  // Set the delegate
//                    cell.addGestureRecognizer(longPressGesture)
//                    if chat.audioFileURL != nil {
//                        if (chat.senderID) ==  myUserDefaults.userId //LoggedUserDetails.shared.user?.id
//                        {
//                            cell.mainBaseView.backgroundColor = AppColors.appBlue.withAlphaComponent(0.1)
//                            cell.mainBaseViewLeading.constant = 70.0
//                            cell.mainBaseViewTralling.constant = 20.0
//                            
//                        } else {
//                            cell.mainBaseView.backgroundColor = .white
//                            cell.mainBaseViewLeading.constant = 20.0
//                            cell.mainBaseViewTralling.constant = 70.0
//                            
//                        }
//                        
//                        cell.audioMainView.isHidden = false
//                        cell.documentStackVw.isHidden = true
//                        cell.docNameLbl.text = chat.actualDocumentName
//                        cell.docSizeLbl.text = chat.documentSize
//                        cell.timeLabel.text = chat.chatTime
//                        cell.imgVw.image = UIImage(named: "ic_chatAudio")
//                        cell.dowmloadBtn.tag = indexPath.row
//                        cell.showDeatilsBtn.tag = indexPath.row
//                        cell.showDeatilsBtn.addTarget(self, action: #selector(AudioMsgDidTap(_:)), for: .touchUpInside)
//                        cell.dowmloadBtn.addTarget(self, action: #selector(downloadAudioTapped(_:)), for: .touchUpInside)
//                    }
//                    return cell
//                }
//                
//                
//            } else if chat.type == .reply {
//                //MARK: Audio - Reply Cell...
//                if let cell = tableView.dequeueReusableCell(withIdentifier: ReplyTVCell.id(), for: indexPath) as? ReplyTVCell {
//                    cell.selectionStyle = .default
//                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                    longPressGesture.delegate = self  // Set the delegate
//                    cell.addGestureRecognizer(longPressGesture)
//                    if (chat.senderID) ==  myUserDefaults.userId //LoggedUserDetails.shared.user?.id
//                    {
//                        cell.wholeBGVWleadingConst.constant = 70.0
//                        cell.wholeBGVWtrailingConst.constant = 20.0
//                        
//                    } else {
//                        cell.wholeBGVWleadingConst.constant = 20.0
//                        cell.wholeBGVWtrailingConst.constant = 70.0
//                        
//                    }
//                    
//                    cell.chat = chat
//                    
//                    return cell
//                }
//            } else {
//                if let cell = tableView.dequeueReusableCell(withIdentifier: DocAudioTVCell.id(), for: indexPath) as? DocAudioTVCell {
//                    cell.selectionStyle = .default
//                    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                    longPressGesture.delegate = self  // Set the delegate
//                    cell.addGestureRecognizer(longPressGesture)
//                    if chat.documentURL != nil {
//                        if (chat.senderID) ==  myUserDefaults.userId //LoggedUserDetails.shared.user?.id
//                        {
//                            cell.mainBaseView.backgroundColor = AppColors.appBlue.withAlphaComponent(0.1)
//                            cell.mainBaseViewLeading.constant = 70.0
//                            cell.mainBaseViewTralling.constant = 20.0
//                            
//                        } else {
//                            cell.mainBaseView.backgroundColor = .white
//                            cell.mainBaseViewLeading.constant = 20.0
//                            cell.mainBaseViewTralling.constant = 70.0
//                        }
//                        
//                        cell.audioMainView.isHidden = true
//                        cell.documentStackVw.isHidden = false
//                        cell.docNameLbl.text = chat.actualDocumentName
//                        cell.docSizeLbl.text = chat.documentSize
//                        cell.timeLabel.text = chat.chatTime
//                        cell.imgVw.image = UIImage(named: "document")
//                        cell.dowmloadBtn.tag = indexPath.row
//                        cell.showDeatilsBtn.tag = indexPath.row
//                        cell.showDeatilsBtn.addTarget(self, action: #selector(DocMsgDidTap(_:)), for: .touchUpInside)
//                        cell.dowmloadBtn.addTarget(self, action: #selector(downloadDocTapped(_:)), for: .touchUpInside)
//                    }
//                    return cell
//                }
//            }
//        }
        print("Last return")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.didSelect.toggle()
//        if didSelect {
//            self.isFeatureOpen = true
//            self.msgFeatureTopVw.isHidden = false
//        } else {
//            self.isFeatureOpen = false
//            self.msgFeatureTopVw.isHidden = true
//        }
        if !isLongPress {
                tableView.deselectRow(at: indexPath, animated: true)
                self.isFeatureOpen = false
                self.msgFeatureTopVw.isHidden = true
            }
    }
//    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        self.didSelect.toggle()
//        if didSelect {
//            self.isFeatureOpen = false
//            self.msgFeatureTopVw.isHidden = true
//        } else {
//            self.isFeatureOpen = true
//            self.msgFeatureTopVw.isHidden = false
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("Indexpath ", indexPath.row)
//        
//        if indexPath.row == (chats.count - 1) {
//            isLstHit = true
//        }
//        
//        if isLstHit {
//            isLstHit = false
//            if indexPath.row == 0 {
////                let lastIndexPath = IndexPath(row: self.tempChats.count - 1, section: 0)
////                self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
//                offsetCount += 1
//                showActivity()
//                print("Chat -- tableview will display")
//                FetchMsgList(id: user?.id ?? userId, offset: self.offsetCount, autoReload: false)
//            } else {
//                
//            }
//       }
//   }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if the content offset is close to the top
        if scrollView.contentOffset.y < 1.0 && endOfData == false {
            print("Top cell reached!")
            if chats.count > 0 {
                self.offsetCount = self.offsetCount + 1
                print("Offset Count :: ",self.offsetCount)
                print("fetch due to scroll")
//                self.tempChats.append(contentsOf: self.chats)
//                self.chats = self.tempChats
//                self.tableView.reloadData()
//                self.scrollToBottom(atRow: 10, animated: false)
                //showActivity()
                //FetchMsgList(id: user?.id ?? userId, offset: self.offsetCount, autoReload: false)
            } else {
                print("Chats is empty.")
            }
        }
    }
    
    @objc func downloadDocTapped(_ sender: UIButton) {
        //if let docURL = chats[sender.tag].documentURL {
        if let docURL = messages[sender.tag].document_url {
            self.showActivity()
            download(url: URL(string: docURL)!, type: "pdf")
        } else { presentAlert("Error", "File Missing.") }
    }
    
    @objc func downloadAudioTapped(_ sender: UIButton) {
        //if let audURL = chats[sender.tag].audioFileURL {
        if let audURL = messages[sender.tag].audio_file_url {
            download(url: URL(string: audURL)!, type: "mp3")
        } else { presentAlert("Error", "File Missing.") }
    }
    
    @objc func openArticle() {
        if let urlString = articleContent, let url = URL(string: urlString) {
            let webVC = WebVC(url: url)
            present(webVC, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        picker = addPicker()
        picker.sourceType = .camera
        DispatchQueue.main.async {
            self.present(self.picker, animated: true)
        }
    }
    
    func showPDF(at: URL) {
            self.hideActivity()
            documentInteractionController = UIDocumentInteractionController(url: at)
            documentInteractionController.delegate = self
            DispatchQueue.main.async { [self] in
                documentInteractionController.presentPreview(animated: true)
            }
        }
    
    func download(url: URL, type: String) {
            let task = URLSession.shared.downloadTask(with: url) { (localURL, response, error) in
                // Check for errors
                guard error == nil else {
                    self.hideActivity()
                    print("Error downloading PDF: \(error!.localizedDescription)")
                    return
                }

                // Check if the response status code indicates success
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Handle the downloaded file
                    if let localURL = localURL {
                        // Move the file to a destination of your choice
                        let currentDate = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MMM-yyyy_HH:mm:ss"
                        let formattedDateString = dateFormatter.string(from: currentDate)
                        let path = "Aviation_\(formattedDateString).\(type)"
                        let destinationURL = self.getDocumentsDirectory().appendingPathComponent(path)
                        print("destinationURL:",destinationURL)
                        do {
                            try FileManager.default.moveItem(at: localURL, to: destinationURL)
                            print("PDF downloaded and saved at: \(destinationURL)")
                            self.showPDF(at: destinationURL)
                        } catch {
                            self.hideActivity()
                            print("Error moving PDF file: \(error.localizedDescription)")
                        }
                    }
                }
            }
            task.resume()
        }

        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }

//    func sameSender(row: Int) {
//
//        //change the message object and put it back.
//        if row != (messages.count - 1) {
//
//            let currentMessage = messages[row]
//            if currentMessage.sender.id == messages[row + 1].sender.id {
//
//                let message = Message(documents: currentMessage.documents, images: currentMessage.images, sameSender: true, sender: currentMessage.sender, messageId: currentMessage.messageId, timeStamp: currentMessage.timeStamp, text: currentMessage.text)
//                messages[row] = message
//
//            }
//        }
//    }
}

extension ChatVC: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 61, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
}

extension ChatVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaAttachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPickerCell.ReuseId, for: indexPath) as? MediaPickerCell {
            
            cell.delegate = self
            cell.removeButton.tag = indexPath.row
            cell.mediaAttachment = mediaAttachments[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
}
// MARK: Handle Camera Image
extension ChatVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            dismiss(animated: true, completion: nil)
            
            if let selectedImage = info[.originalImage] as? UIImage {
                // Process or use the selected image as needed
                self.showActivity()
                self.postImages.append(selectedImage)
                if self.messageTextView.text == "" && self.postImages.isEmpty && self.documentURL == nil && self.audioURL == nil { return }
                self.CreateMsg(id: self.user?.id ?? self.userId , Msg: self.messageTextView.text, fileName: self.fileName)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            
//            self.postImages[0] = pickedImage
//            if self.messageTextView.text == "" && self.postImages.isEmpty && self.documentURL == nil && self.audioURL == nil { return }
//            self.CreateMsg(id: self.user?.id ?? self.userId , Msg: self.messageTextView.text, fileName: self.fileName)
//            
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            mediaAttachments.append(MediaAttachment(fileURL: nil, image: image, type: .image))
//            picker.dismiss(animated: true, completion: nil)
//            attachments.isHidden = true
//
//        }
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////        dismiss(animated: true, completion: nil)
//        
//        if let mediaType = info[.mediaType] as? String {
//            if mediaType == kUTTypeImage as String {
//                // Handle image
//                if let image = info[.originalImage] as? UIImage {
//                    // Process the selected image
//                    self.postImages[0] = image
//                    if self.messageTextView.text == "" && self.postImages.isEmpty && self.documentURL == nil && self.audioURL == nil { return }
//                    self.CreateMsg(id: self.user?.id ?? self.userId , Msg: self.messageTextView.text, fileName: self.fileName)
//                }
//            } else if mediaType == kUTTypeMovie as String {
//                if let videoURL = info[.mediaURL] as? URL {
//                    
//                    compressVideo(inputURL: videoURL, outputURL: self.videoURL!) { compressedURL in
//                        if let compressedURL = compressedURL {
//                            // Compression successful, use the compressed video URL
//                            print("Compression successful. Compressed video saved at \(compressedURL)")
//                        } else {
//                            // Compression failed
//                            print("Compression failed.")
//                        }
//                    }
//                }
//            }
//        }
//    }
    
}

extension ChatVC: SelectionCellActionable {
    
    func selectedButton(sender: UIButton, completion: @escaping () -> Void) {
        mediaAttachments.remove(at: sender.tag)
        completion()
    }
}


extension ChatVC: SelectionCVDocumentActionable {
    // for navigation to web view to open the document
    func selectedDocument(url: URL) {
        let webVC = WebVC(url: url)
        webVC.modalPresentationStyle = .formSheet
        present(webVC, animated: true, completion: nil)
    }
}

// MARK: - Document Interaction Controller Delegate methods -
extension ChatVC: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        self
     }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        documentInteractionController = nil
    }
    
}

extension ChatVC: UIDocumentPickerDelegate {
    
    private func openFile() {
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet, kUTTypeCompositeContent]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func showDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeText), String(kUTTypePlainText)], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else {
            return
        }

        // Handle the selected document URL (e.g., display, upload, process, etc.)
        print("Selected document URL: \(selectedURL)")
        
        let urlStr = "\(selectedURL)"
        fileName = selectedURL.lastPathComponent
        let fileExtension = (urlStr as NSString).pathExtension.lowercased()

            switch fileExtension {
            case "mp3":
                audioURL = selectedURL
                print("\(selectedURL) is an MP3 file.")
            case "pdf":
                documentURL = selectedURL
                print("\(selectedURL) is a PDF file.")
            default:
                if postType == .audio {
                    presentAlert("Alert","Please select MP3 files only.")
                } else if postType == .doc {
                    presentAlert("Alert","Please select PDF files only.")
                }
            }
        if messageTextView.text.isEmpty && self.imageArray.isEmpty && self.documentURL == nil && self.audioURL == nil { return }
        self.CreateMsg(id: self.user?.id ?? self.userId , Msg: self.messageTextView.text, fileName: self.fileName)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle the cancellation of the document picker
        print("Document picker was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        
//        let urlStr = "\(url)"
//        fileName = url.lastPathComponent
//        let fileExtension = (urlStr as NSString).pathExtension.lowercased()
//
//            switch fileExtension {
//            case "mp3":
//                audioURL = url
//                print("\(url) is an MP3 file.")
//            case "pdf":
//                documentURL = url
//                print("\(url) is a PDF file.")
//            default:
//                print("Unknown file format for \(url).")
//            }
//        if messageTextView.text.isEmpty && self.imageArray.isEmpty && self.documentURL == nil && self.audioURL == nil { return }
//        self.CreateMsg(id: self.user?.id ?? self.userId , Msg: self.messageTextView.text, fileName: self.fileName)
////        fileNameLbl.text = url.lastPathComponent
////        fileNameLbl.isHidden = false
//    }
    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//
//             let fileManager = FileManager.default
//             // Get document directory for device, this should succeed
//              let documentDirectory = fileManager.urls(for: .documentDirectory,
//                                                         in: .userDomainMask).first!
//                 // Construct a URL with desired folder name
//                 let folderURL = documentDirectory.appendingPathComponent("EvaDocuments")
//                 // If folder URL does not exist, create it
//                 if !fileManager.fileExists(atPath: folderURL.path) {
//                     do {
//                         try fileManager.createDirectory(atPath: folderURL.path,
//                                                         withIntermediateDirectories: true,
//                                                         attributes: nil)
//                     } catch {
//                         print(error.localizedDescription)
//                     }
//                 }
//
//        let savePdfUrl = folderURL.appendingPathComponent(url.lastPathComponent)
//
//        do { try FileManager.default.moveItem(at: url, to: savePdfUrl) }
//        catch {
//            print("error") }
//
//        mediaAttachments.append(MediaAttachment(fileURL: url, image: nil, type: .document))
//        attachments.isHidden = true
//    }
}

extension ChatVC {
    
    private func setNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDismiss),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
//        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//        
//        UIView.animate(withDuration: 0.25) {
//            self.bottomConstraint.constant = keyboardHeight <= 290 ? 290 : keyboardHeight - 90
//            self.view.layoutIfNeeded()
//        } completion: { _ in
////            self.scrollToBottom(atRow: self.messages.count - 1, animated: true)
//        }
    }
    
    @objc func keyboardWillDismiss(_ notification: Notification) {
//        UIView.animate(withDuration: 0.25) {
//            self.bottomConstraint.constant = 0
//            self.view.layoutIfNeeded()
//        }
    }
}

extension ChatVC {
    
//    private func getBlockedConnectionListing() {
//
//        var userId = ""
//        if let member = conversation?.memebers.first(where: { $0.id != String(LoggedUserDetails.shared.user!.id ?? 0) }) { userId = member.id }
//        else if let uid = user?.id { userId = String(uid) }
//
//        ProfileManager.shared.getConnectionStatus(targetId: userId) { (isBlocked) in
//            if isBlocked {
////                self.sendMessageView.isHidden = true
//                self.blockedView.isHidden = false
////                self.sendMessageView.isUserInteractionEnabled = false
//            } else {
////                self.sendMessageView.isUserInteractionEnabled = true
//            }
//        }
//
//    }
    
    
//    private func getChatNotificationSetting() {
//        guard let id = conversation?.user?.id else { return }
//        let params: AFParameters = ["user_id": "\(id)"]
//        guard let url = params.getURL(EndPoints.addPushNotificationSettings) else { return }
//        NetworkManagerr.request(url) { [weak self] (result: Result<Wrapper<[PushNotificationSettings]>>) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let rsl):
//                if let notifications = rsl.data.last?.notifications {
//                    self.sendPushNotification = notifications.filter({ $0.key == UserNotificationSetting.message.apiKey }).first?.value == 1
//                }
//            case .failure(let error):
//                print("error", error.localizedDescription)
//            }
//        }
//    }
}

//--> File COmpression....
extension ChatVC {
    func fileSizeInMB(url: URL) -> Double {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = fileAttributes[.size] as? NSNumber {
                return fileSize.doubleValue / (1024.0 * 1024.0) // Convert to MB
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return 0.0
    }
    
    func compressImageToMax5MB(_ image: UIImage) -> Data? {
        var compression: CGFloat = 0.8
        let maxFileSize = 5.0 * 1024 * 1024 // 5MB
        
        guard var imageData = image.jpegData(compressionQuality: compression) else { return nil }
        
        while Double(imageData.count) > maxFileSize && compression > 0.05 {
            compression -= 0.1
            if let data = image.jpegData(compressionQuality: compression) {
                imageData = data
            }
        }
        
        return imageData
    }
    
    func compressVideo(inputURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: inputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            completion(nil)
            return
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("compressed.mp4")
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completion(outputURL)
            } else {
                print("Video compression failed: \(String(describing: exportSession.error))")
                completion(nil)
            }
        }
    }
        
    func compressAudio(inputURL: URL, completion: @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: inputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completion(nil)
            return
        }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("compressed.m4a")
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .m4a
        
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completion(outputURL)
            } else {
                print("Audio compression failed: \(String(describing: exportSession.error))")
                completion(nil)
            }
        }
    }

}
