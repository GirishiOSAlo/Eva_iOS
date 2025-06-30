//
//  ProfileVC.swift
//  EvaConnect
//
//  Created by usama on 02/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileVC: BaseVC {

    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var headerLocatin: UILabel!
    
    @IBOutlet weak var imageContainer: UIView!

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var sector: UITextField!
    @IBOutlet weak var otherSector: UITextField!
    @IBOutlet weak var saveChanges: UIButton!
    @IBOutlet weak var otherSectorStack: UIStackView!
    @IBOutlet weak var jobTitleStack: UIStackView!
    
    var sectors: [String] = []
    let imagePicker = UIImagePickerController()
    var imageChanged = false
    var userDetail : EvaUser?
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
}

extension EditProfileVC {
    
    func initUI() {
        
        (headerLocatin as? HeadingTwoLabel)?.textColor = AppColors.lightBg
        headerName.font = UIFont(defaultFontStyle: .bold, size: 20)
        imageContainer.layer.borderColor = AppColors.evaBlue.cgColor
        imageContainer.layer.borderWidth = 2.0
        imageContainer.roundOnly()
        userAvatar.roundOnly()
        imagePicker.delegate = self
        saveChanges.backgroundColor = AppColors.dullRed
        
        if let user = userDetail {
        
            headerName.text = (user.firstName ?? "") + " " +  user.lastName.stringValue
            headerLocatin.text = user.address.stringValue

            name.text = (user.firstName ?? "") + user.lastName.stringValue
            //location.text = user.address.stringValue
            company.text = user.companyName.stringValue
            titleTF.text = user.designation.stringValue
            location.text = user.locationAddress
            location.isEnabled = false
            if let image = user.userImage, let url = URL(string: image) {
                
                userAvatar.kf.setImage(with: url)
            }
            otherFieldOption(value: user.sector ?? "", isViewLoaded: .allow)
            if user.type == "company" {
                jobTitleStack.isHidden = true
            } else {
                jobTitleStack.isHidden = false
            }
        }
        
        sector.inputView = pickerView
        sector.isUserInteractionEnabled = false
//        getSectors()
    }
    private func otherFieldOption(value: String,isViewLoaded: OtherSectorVisiblity) {
        if "Other" == value {
            
            if isViewLoaded == .allow {
                otherSector.text = userDetail!.otherSector.stringValue
            } else {
                refreshOtherSector()
            }
            otherSectorStack.isHidden = false
            sector.text = userDetail!.sector.stringValue
            
        } else {
            otherSectorStack.isHidden = true
            sector.text = userDetail!.sector.stringValue
        }
    }
    
//    func getSectors() {
//
//        // get call
//        let params = [:] as [String: Any]
//
//        showActivity()
//        NetworkManagerr.request(EndPoints.getSectors, method: .post, parameters: params) { (response) in
//
//            self.hideActivity()
//            let jsonDecoder = JSONDecoder()
//            let sectors = try? jsonDecoder.decode(AllSectorModel.self, from: response.data!)
//
//            if let sectors = sectors {
//                self.sectors.append(contentsOf: sectors.data)
//            }
//        }
//    }
    
    func updateDetails() {
        
    }
}

extension EditProfileVC {
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func editPicture_touchUpInside(_ sender: UIButton) {
         present(imagePicker, animated: true, completion: nil)
     }

    @IBAction func save_touchUpInside(_ sender: UIButton) {
        if "Other" == sector.text! {
            if !otherSector.text.isNilOrEmpty {
                
                if let user = LoggedUserDetails.shared.user {
                    
                    var parameters: Parameters = ["modified_by_id": user.id,
                        "modified_datetime": Date().toString(formatter: .standardDateWithTime)]
                    
                    if name.text !=  (user.firstName ?? "") + " " +  user.lastName.stringValue {
                        parameters["name"] = name.text!
                    }
                    
        //            if location.text !=  user.city {
        //                parameters["name"] = name.text!
        //            }
                    
                    if company.text != user.companyName {
                        parameters["company_name"] = company.text!
                    }
                    
                    if titleTF.text != user.designation {
                        parameters["designation"] = titleTF.text!
                    }
                    
                    if sector.text != user.sector{
                        parameters["sector"] = sector.text!
                    }
                    if otherSector.text != user.otherSector {
                        parameters["other_sector"] = otherSector.text!
                    }
                            
                    
                    var images: [UIImage] = []
                    if imageChanged {
                        images.append(userAvatar.image!)
                    }
                    print(parameters)
                    updateUserDetail(parameters: parameters, images: images,user: user)
                }
                
            } else {
                
                presentAlert("Other Sector is Empty", nil, nil)
            }
        }  else {
            
            if let user = LoggedUserDetails.shared.user {
                
                var parameters: Parameters = ["modified_by_id": user.id,
                    "modified_datetime": Date().toString(formatter: .standardDateWithTime)]
                
                if name.text !=  (user.firstName ?? "") + " " +  user.lastName.stringValue {
                    parameters["name"] = name.text!
                }
                
    //            if location.text !=  user.city {
    //                parameters["name"] = name.text!
    //            }
                
                if company.text != user.companyName {
                    parameters["company_name"] = company.text!
                }
                
                if titleTF.text != user.designation {
                    parameters["designation"] = titleTF.text!
                }
         
                if sector.text != user.sector {
                    parameters["sector"] = sector.text!
                }
                        
                
                var images: [UIImage] = []
                if imageChanged {
                    images.append(userAvatar.image!)
                }
                
                updateUserDetail(parameters: parameters, images: images,user: user)
            
            }
            
        }
       
    }
    private func updateUserDetail(parameters: Parameters, images: [UIImage],user: EvaUser) {
        
        NetworkManagerr.requestWithImages(EndPoints.editProfile, images: images, imageName: "user_image", method: .patch, parameters: parameters) { (succesfulUpload, error) in
            
            if let _ = succesfulUpload {
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let loginUser = try jsonDecoder.decode(LoginStruct.self, from: (succesfulUpload?.data)!)
                    
                    
                    
                    if let data = loginUser.data ,!loginUser.error  {
                        
                        LoggedUserDetails.shared.updateUser(userModel: data[0])
                        BaseVC.saveUser(user: user)
//                        print(LoggedUserDetails.shared.user!.id)
                        
                        
                        self.presentAlertWithAction(title: "Success", message: "Profile Updated") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                } catch {
                    self.presentAlert("Failure", nil, error)
                }
            }
        }
    }
}


extension EditProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sectors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        sectors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        otherFieldOption(value: sectors[row], isViewLoaded: .disable)
        sector.text = sectors[row]
        
    }
    private func refreshOtherSector(){
        otherSector.text = ""
    }
}

extension EditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editImage = info[.editedImage] as? UIImage
        var orignalImage = info[.originalImage] as? UIImage
        if editImage != orignalImage {
            orignalImage = editImage
        }
        userAvatar.image = orignalImage
        imageChanged = true
        picker.dismiss(animated: true, completion: nil)
        
    }
}
enum OtherSectorVisiblity {
   case disable
   case allow
}
