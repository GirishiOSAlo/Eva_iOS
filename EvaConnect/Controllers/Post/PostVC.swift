//
//  PostVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/3/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import URLEmbeddedView
import Alamofire

class PostVC: BaseVC {

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var embeddedView: URLEmbeddedView!
    @IBOutlet weak var pickContentBtn: UIButton!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTV: UITextView!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var documentBtn: UIButton!
    @IBOutlet weak var postMainView: UIView!
    
    private var contents: [PostContent] = [.text("What do you want to talk about ?", 16)]
    private var contentPicker: BottomContentPicker!
    private var previousLink = ""
    
    var mode: PostLoadingMode = .create
    var postType: PostType = .simpleText
    var data: DashboardItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSeparatorHidden = true
        self.navigationController?.isNavigationBarHidden = true
        applyUserData()
        setTableView()
        setContentPickerView()
        
        postBtn.layer.cornerRadius = self.postBtn.frame.size.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cell = tableView.visibleCells.first as? TextViewCell {
            cell.textView.text = contents.first?.text ?? ""
            cell.textView.textColor = (contents.first?.text ?? "") == "What do you want to talk about ?" ? UIColor(hex: "#000000", alpha: 0.4) : .black
            cell.textViewDidChange(cell.textView)
        }
    }
    
    @IBAction func galleryTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func addDocTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func pickContentBtnTapped(_ sender: Any) { contentPicker.presentView() }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        if (contents.first?.text.trim.isEmpty ?? false) || (tableView.visibleCells.first as? TextViewCell)?.textView.textColor == .lightGray  {
            ErrorView(contentView: navigationController?.view ?? view).show(message: Constants.Label.emptyPost)
            return
        }
        
        PostManager().createUpdatePost(contents: contents, postId: data?.id) { [weak self] (result: Alamofire.Result<GenericResponse>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(let res):
                if res.error { self.presentAlert(Constants.Label.error, res.message) }
                else { self.resetAndNavigateToHome() }
            case .failure(let error):
                self.presentAlert(Constants.Label.error, nil, error)
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
//        if mode == .create { tabBarController?.selectedIndex = 0 }
//        else { goBack() }
        goBack()
    }
}

extension PostVC {
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerCells(withTypes: [TextViewCell.self,
                                            PostImageViewCell.self,
                                            PostDocumentCell.self])
    }
    
    private func setContentPickerView() {
        contentPicker = BottomContentPicker(contents: [(title: "Add photo or video", type: .photo),
                                                       (title: "Add document", type: .document),
                                                       (title: "Add a URL link", type: .link)])
        contentPicker.delegate = self
        contentPicker.addConstraint((UIApplication.shared.keyWindow ?? view))
        picker.delegate = self
    }
    
    private func applyUserData() {
        guard let user = LoggedUserDetails.shared.user else { return }
        nameLbl.text = user.fullName
        profilePictureImageView.sd_setImage(with: URL(string: user.isLinkedin == 0 ? user.userImage ?? "" : user.linkedinImageURL ?? ""),
                                            placeholderImage: #imageLiteral(resourceName: "noImage"))
        
        if let data = data, mode == .edit {
            postBtn.setTitle("Update Post", for: .normal)
            fillPostData(data)
        }
    }
    
    private func resetAndNavigateToHome() {
        contents.removeAll()
        contents.append(.text("What do you want to talk about ?", 16))
        tableView.reloadData()
        if data.isNil { tabBarController?.selectedIndex = 0 }
        else { navigationController?.popViewController(animated: true) }
    }
}

extension PostVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { contents.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch contents[indexPath.item] {
        case .text(let text, _):
            let cell: TextViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            
            cell.text = text
            return cell
        case .image(let url, let image):
            let cell: PostImageViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            cell.data = (index: indexPath.item, url: url, image: image)
            cell.mode = mode
            return cell
        case .video(_, let image):
            let cell: PostImageViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            cell.video = (index: indexPath.item, thumbnail: image)
            cell.mode = mode
            return cell
        case .document(let url):
            let cell: PostDocumentCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            cell.content = (index: indexPath.item, url: url)
            cell.mode = mode
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch contents[indexPath.item] {
        case .text(_, let height):
            return height + 50
        default:
            return 240
        }
    }
}

extension PostVC: TextViewCellDelegate {
    
    func updateTextViewHeight(_ text: String, _ height: CGFloat) {
        contents[0] = .text(text, height)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewLinkDetector(_ url: URL?) {
        guard let url = url else {
            embeddedView.isHidden = true
            return
        }
        
        if previousLink == url.absoluteString { return }
        embeddedView.load(urlString: url.absoluteString)
        previousLink = url.absoluteString
        embeddedView.isHidden = false
    }
}

extension PostVC: PostTableViewCellDelegate {
    
    func didRemoveCell(at index: Int, hasImage: Bool) {
        contents.remove(at: index)
        tableView.reloadData()
        //tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
    }
}

extension PostVC: BottomContentPickerDelegate {
    
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType) {
        switch content {
        case .photo:
            openGalleryy(video: !contents.contains(where: { $0.isImage }))
        case .document:
            contents.contains(where: { $0.isImage || $0.isVideo }) ? presentAlert(Constants.Label.error, Constants.Label.documentAttactedError) : openFile()
        case .link:
            print("open link")
        default:
            print("none")
        }
    }
    
}

extension PostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            contents.append(.image(nil, image))
            tableView.insertRows(at: [IndexPath(item: contents.count - 1, section: 0)], with: .automatic)
        } else if let url = info[.mediaURL] as? URL { generateVideoThumbnail(url: url) }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func generateVideoThumbnail(url: URL, loading: Bool = false) {
        AVAsset(url: url).generateThumbnail { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async {
                self.contents.append(.video(url, image))
                self.tableView.insertRows(at: [IndexPath(item: self.contents.count - 1, section: 0)], with: .automatic)
                if loading { self.hideActivity() }
            }
        }
    }
}

extension PostVC: UIDocumentPickerDelegate {
    
    private func openFile() {
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet,kUTTypeCompositeContent]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        contents.append(.document(url))
        tableView.insertRows(at: [IndexPath(item: contents.count - 1, section: 0)], with: .automatic)
    }
    
}

extension PostVC {
    
    private func fillPostData(_ data: DashboardItem) {
        
        switch postType {
        case .simpleText:
            contents = [.text(data.content ?? "", 40)]
        case .image:
            contents = [.text(data.content ?? "", 40)] + (data.datumPostImage?.compactMap({ $0 }).map({ PostContent.image(URL(string: $0), nil) }) ?? [])
        case .video:
            contents = [.text(data.content ?? "", 40)]
            if let url = URL(string: data.postVideo ?? "") {
                showActivity()
                generateVideoThumbnail(url: url, loading: true)
            }
        case .article:
            if let url = URL(string: data.postDocument ?? "") { contents = [.text(data.content ?? "", 40), .document(url)] }
        }
        
        showActivity()
        textViewLinkDetector(data.content?.link)
        tableView.isHidden = true
        tableView.reloadData()
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [unowned self] _ in
            tableView.isHidden = false
            if postType != .video { hideActivity() }
            if let cell = tableView.visibleCells.first as? TextViewCell {
                cell.textView.text = data.content ?? ""
                cell.textView.textColor = .black
                cell.textViewDidChange(cell.textView)
            }
        }
    }
    
}
