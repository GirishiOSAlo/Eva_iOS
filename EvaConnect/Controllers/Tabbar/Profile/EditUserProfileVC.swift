//
//  EditUserProfileVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/28/21.
//  Copyright © 2021 HyperNym. All rights reserved.


import UIKit
import Alamofire
import MobileCoreServices

protocol EditUserProfileDelegate {
    func didProfileUpdated(item: EditProfile, value: String)
}

class EditUserProfileVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    private var editProfileItems = [EditProfile]()
    var userDetail: EvaUser!
    var isCompany = LoggedUserDetails.shared.user?.type == userType.company.rawValue
    
    @IBOutlet weak var profileImageBaseVw: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadPhotoBtnMainVw: UIView!
    @IBOutlet weak var companyNameBaseVw: UIView!
    @IBOutlet weak var jobTitleBaseVw: UIView!
    @IBOutlet weak var locationBaseVw: UIView!
    @IBOutlet weak var bioBaseVw: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var jobTitleWholeView: UIView!
    var sizeCheck = false
    private var user = LoggedUserDetails.shared.user
    
    var profilePic: UIImage?
    var base64String: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSeparatorHidden = true
        editProfileItems = isCompany ? EditProfile.company : EditProfile.user
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setUserData()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setLayout() {
        
        jobTitleWholeView.isHidden = !isIndivisualUser
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.profileImageBaseVw.layer.cornerRadius = self.profileImageBaseVw.frame.size.height/2
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2
        self.saveButton.layer.cornerRadius = self.saveButton.frame.size.height/2
        self.uploadPhotoBtnMainVw.layer.cornerRadius = self.uploadPhotoBtnMainVw.frame.size.height/2
        
        applyBorderAndRadius(view: self.companyNameBaseVw, borderWidth: 0.5, borderColor: UIColor(hex: "#837A88"), cornerRadius: 8)
        applyBorderAndRadius(view: self.jobTitleBaseVw, borderWidth: 0.5, borderColor: UIColor(hex: "#837A88"), cornerRadius: 8)
        applyBorderAndRadius(view: self.locationBaseVw, borderWidth: 0.5, borderColor: UIColor(hex: "#837A88"), cornerRadius: 8)
        applyBorderAndRadius(view: self.bioBaseVw, borderWidth: 0.5, borderColor: UIColor(hex: "#837A88"), cornerRadius: 8)
        
        self.profileImageBaseVw.borderWidth = 1
        self.profileImageBaseVw.borderColor = UIColor(hex: "#B9CEED")
        
//        jobTitleTextField.text = LoggedUserDetails.shared.user
    }
    
    @IBAction func onUploadPhotoBtnTapped(_ sender: UIButton) {
            addNewPicture()
    }

    func addPicker() -> UIImagePickerController{
       
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }
    
    func addNewPicture() {
       picker = addPicker()
        DispatchQueue.main.async {
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
//    @objc func openGallery() {
//        //pickImageCallback = callback;
//        //self.viewController = viewController;
//        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
//            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
//                self.picker.sourceType = .camera
//                self.picker.allowsEditing = true
//                self.present(self.picker, animated: true, completion: nil)
//            } else {
//                let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
//                alertWarning.show()
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (UIAlertAction) in
//            self.picker.sourceType = .photoLibrary
//            self.picker.allowsEditing = true
//            self.picker.modalPresentationStyle = .fullScreen
//            self.present(self.picker, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @IBAction func updateProfileTapped(_ sender: UIButton) {
        let user = LoggedUserDetails.shared.user
        showActivity()
        if profilePic != nil || jobTitleTextField.text != user?.designation || companyNameTextField.text != (isIndivisualUser ? user?.companyName : user?.firstName) || bioTextView.text !=  user?.bioData {
            updateProfile(jobTitle: jobTitleTextField.text ?? "", companyName: companyNameTextField.text ?? "", region: "Asia", bio: bioTextView.text ?? "") { success, error in
                if success ?? false {
                    print("Done!!")
                    self.fetchUserDetail()
                }
                if let error = error {
                    print(error)
                    print(error.localizedDescription)
                }
            }
        } else {
            print("No need to update")
            goBack()
        }
    }
    
    func applyBorderAndRadius(view: UIView, borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat) {
        
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor
        view.clipsToBounds = true
    }
}

//MARK: - ImagePicker Delegate (Single)
extension EditUserProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = pickedImage
            self.profilePic = pickedImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditUserProfileVC {
    func updateProfile(jobTitle: String, companyName: String, region: String, bio: String, completion: @escaping (Bool?, Error?) -> Void) {

        var parameters: AFParameters = [:]
        if isIndivisualUser {
             parameters = ["is_online": true,
                           "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                           "first_name": myUserDefaults.fullName,
                           "last_name": "",
                            "designation": jobTitle,
                            "region": region,
                            "company_name": companyName,
                            "bio_data": bio,
                            "is_public": 0,
                            "last_online_datetime": Date().toString(formatter: .standardDateWithTime)]
        } else {
             parameters = ["is_online": true,
                            "modified_by_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                            "first_name": companyName,
                            "last_name": "",//LoggedUserDetails.shared.user?.lastName ?? "",
                            "designation": jobTitle,
                            "region": region,
                            "company_update_id": myUserDefaults.userId, //LoggedUserDetails.shared.user!.id ?? 0,
                            "bio_data": bio,
                            "is_public": 0,
                            "last_online_datetime": Date().toString(formatter: .standardDateWithTime)]
        }
        
        if let imageData = profilePic?.jpegData(compressionQuality: 0.50) {
                let base64ImageString = imageData.base64EncodedString(options: [])
                base64String = "data:image/png;base64,\(base64ImageString)"
                parameters["user_image"] = base64String
        } else {
            print("No need to update Image")
        }
        
        let endPoint = EndPoints.userDetail

        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in

            if response.result.isSuccess {

                let jsonDecoder = JSONDecoder()

                do {

                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        self.presentAlert(genericRoot.error ? "Error" : "Success", "Profile Updated.", nil) {
                            if !genericRoot.error { self.goBack() }
                        }
                        completion(true, nil)
                    } else {
                        self.hideActivity()
                        completion(nil, response.result.error)
                    }
                } catch {
                    self.hideActivity()
                    completion(nil, response.result.error)
                }
            } else {
                self.hideActivity()
                completion(nil, response.result.error)
            }
        }
    }
    
    private func fetchUserDetail() {
        ProfileManager.shared.fetchUserDetail(userId: user?.id ?? 0, showLoader: false) { user, error in
            if let error = error {
                self.hideActivity()
                self.presentAlert("Error", error)
            } else if let user = user {
                self.user = user
                LoggedUserDetails.shared.updateUser(userModel: user)
                self.setUserData()
            } else {
                self.hideActivity()
                self.presentAlert("Error", "Unable to fetch user details")
            }
        }
    }
    
    func setUserData() {
        navigationController?.navigationBar.isHidden = true
        profileImageView.kf.setImage(with: URL(string: LoggedUserDetails.shared.user?.userImage ?? ""))
        bioTextView.text = LoggedUserDetails.shared.user?.bioData
        companyNameTextField.text = isIndivisualUser ? LoggedUserDetails.shared.user?.companyName : LoggedUserDetails.shared.user?.firstName
        jobTitleTextField.text = LoggedUserDetails.shared.user?.designation
        self.hideActivity()
    }
}

extension EditUserProfileVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { editProfileItems.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditUserProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.title = editProfileItems[indexPath.item].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 63 }
    
}

extension EditUserProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.navigationBar.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch editProfileItems[indexPath.item] {
        case .profilePicture, .companyLogo:
            let vc = StoryboardRouter.editProfilePicture()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .jobTitle:
            let vc = StoryboardRouter.editJobTitle()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .bio, .companyBio:
            let vc = StoryboardRouter.signUpAboutInfo()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .password:
            let vc = StoryboardRouter.signUpPassword()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .location:
            let vc = StoryboardRouter.signUpLocationDOB()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

//extension EditUserProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
//        print("picked mediatype = \(mediaType)")
//
//        if mediaType == kUTTypeImage as String {
//
//            let editImage = info[.editedImage] as? UIImage
//            var orignalImage = info[.originalImage] as? UIImage
//            if editImage != orignalImage {
//                orignalImage = editImage
//            }
//            let imgData = NSData(data: (orignalImage!).jpegData(compressionQuality: 0.8)!)
//
//            let imageSize: Int = imgData.count
//
//
//            //chekcing size if its 4mb
//            if  imageSize <= 4194304 {
//                self.profileImageView.contentMode = .scaleAspectFill
//                self.sizeCheck = true
//                self.profileImageView.image = orignalImage
//                print("Image\(orignalImage!)")
//            } else {
//                sizeCheck = false
//            }
//            dismiss(animated: true, completion: nil)
//
//            if !sizeCheck {
//                makeAlert(messageData: "Image File must be less than equal to 4 MB")
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion:nil)
//    }
//}

extension EditUserProfileVC: EditUserProfileDelegate {
    
    func didProfileUpdated(item: EditProfile, value: String) {
        var _: Parameters = ["modified_by_id": userDetail.id, "modified_datetime": Date().toString(formatter: .standardDateWithTime)]
        
        switch item {
        case .profilePicture, .companyLogo:
            print("profilePicture")
        case .jobTitle:
            print("jobTitle")
        case .bio, .companyBio:
            print("bio")
        case .password:
            print("password")
        case .location:
            print("location")
        }
    }
    
}
