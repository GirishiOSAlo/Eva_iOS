//
//  EditProfilePictureVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/28/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class EditProfilePictureVC: BaseForAuthentication {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var uploadImageBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBorderView: UIView!
    
    private var user: EvaUser = LoggedUserDetails.shared.user!
    private var imageAttached: Bool = false
    var delegate: EditUserProfileDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadBtnTapped(_ sender: Any) {
        openGallery()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        imageAttached ? updateUserImage() : goBack()
    }
    
}

extension EditProfilePictureVC {
    
    private func setLayout() {
        picker.delegate = self
        
        profileBorderView.makeRoundView(boderColor: Constants.AppColorLiteral.loginByNew)
        giveButtonCorner(actionBtn: submitBtn, backColor: Constants.AppColorLiteral.nextButtonColor)
        giveButtonCorner(actionBtn: uploadImageBtn, backColor: .white, giveShadow: true)
        
        if user.userImage != nil {
            profileImageView.sd_setImage(with: URL(string: user.isLinkedin == 0 ? user.userImage ?? "" : user.linkedinImageURL ?? ""),
                                         placeholderImage: #imageLiteral(resourceName: "profile"))
        }
    }
    
}

extension EditProfilePictureVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImageView.image = image
            imageAttached = true
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension EditProfilePictureVC {
    
    private func updateUserImage() {
        guard let image = profileImageView.image else { return }
        submitBtn.isUserInteractionEnabled.toggle()
        ProfileManager.shared.updateProfile(params: [:], images: [image]) { [weak self] (error, message) in
            self?.submitBtn.isUserInteractionEnabled.toggle()
            if error { self?.presentAlert("Error", message, nil) }
            else { self?.navigationController?.popViewController(animated: true)  }
        }
    }
    
}
