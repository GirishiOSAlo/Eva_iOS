//
//  editJobPostV2.swift
//  EvaConnect
//
//  Created by Metis on 06/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//


//
//  addJobPost.swift
//  EvaConnect
//
//  Created by Metis on 26/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//
protocol refreshJobDetailCall : class{
    func refreshJobDetail(checkForCall:Bool,JobIdDetail:Int)
}

import UIKit
import IHProgressHUD
import Alamofire

class EditPostedJobVC: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var sectorBtn: UIButton!
    @IBOutlet weak var sectorTxt: UITextField!
    @IBOutlet weak var companyTxt: UITextField!
    @IBOutlet weak var salaryTxt: UITextField!
    @IBOutlet weak var positionTxt: UITextField!
    @IBOutlet weak var updateJobBtn:UIButton!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var jobTitleTxt: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var browseBtn: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var jobTypeTxt: UITextField!
    @IBOutlet var boderView: UIView!
    
    //MARK: VARIABLES
    var checkPickerData = 0
    var pickerArray = ["Piolots", "ITSystems", "Security"]
    var pickerView : UIPickerView?
    weak var delegate: refreshJobDetailCall?
    var jobId: Int?
    var jobEdit: EditedJob?
    var sizeCheck = false
    var generalAviationArray: [String] = []
    var getHours = ""
    var jobTypeList: [String] = []
    //MARK:-VIEW LIFECYLCE
    
    override func viewDidLoad() {
       super.viewDidLoad()
        setLayOut()
    }
    
    @IBAction func sectorAction(_ sender: Any) {
        checkPickerData = 0
        pickerArray = generalAviationArray
        pickerView?.reloadAllComponents()
    }
 
   @IBAction func jobTypeAction(_ sender: Any) {
        checkPickerData = 1
        pickerArray = jobTypeList
        pickerView?.reloadAllComponents()
    }
    @IBAction func createJobAd(_ sender: Any){
        if !companyTxt.text!.isEmpty &&
            !sectorTxt.text!.isEmpty && !positionTxt.text!.isEmpty && !descriptionTextField.text!.isEmpty &&  !salaryTxt.text!.isEmpty && !locationTxt.text!.isEmpty && profileImg.image != nil && !jobTitleTxt.text!.isEmpty && !jobTypeTxt.text!.isEmpty {
            updateJobAdPost(jobType: jobTypeTxt.text!,
                            jobNature: companyTxt.text!,
                            jobSector:sectorTxt.text!,
                            jobTitle: jobTitleTxt.text!,
                            position: positionTxt.text!,
                            content: descriptionTextField.text!,
                            salary: salaryTxt.text!,
                            location: locationTxt.text!,
                            UploadImage: profileImg)
        }
        else{
            makeAlert(messageData: "All Fields are mandatory")
        }
    }
    @IBAction func browseAction(_ sender: Any) {
        openGalleryy()
    }
    @IBAction func back_touchUpInside(_ sender: UIButton) {
           navigationController?.popViewController(animated: true)
       }
}

//MARK:- TextField Delegates

extension EditPostedJobVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
            
        case sectorTxt:
            pickerArray = generalAviationArray
            checkPickerData = 0
            
        case jobTypeTxt:
            pickerArray = jobTypeList
            checkPickerData = 1
            pickerView?.reloadAllComponents()
            
        default:
            break
            
        }
        
        pickerView?.reloadAllComponents()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == salaryTxt {
            let maxLength = 9
            guard NSCharacterSet(charactersIn: "0123456789").isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet) else {
                return false
            }
            let currentString: NSString = textField.text! as NSString
            
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else {
            return false
        }
    }
}


extension EditPostedJobVC:UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK:-Picker DELEGATES
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if checkPickerData == 0 {
            return pickerArray[row]
        } else {
            return pickerArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if checkPickerData == 0 {
            sectorTxt.text = pickerArray[row]
        }
    
        if checkPickerData == 1{
            
            jobTypeTxt.text = pickerArray[row]
        }
    }
    
    //MARK:-ApiCALLING
    func getSectors() {
        
        // get call
        let params = [:] as [String: Any]
        
        NetworkManagerr.request(EndPoints.getSectors, method: .post, parameters: params) { (response) in
            
            let jsonDecoder = JSONDecoder()
            let sectors = try? jsonDecoder.decode(AllSectorModel.self, from: response.data!)
            
            if let sectors = sectors {
                
                self.generalAviationArray.append(contentsOf: sectors.data)
                
            }
        }
    }
    func getJobTypes() {
        // get call
        NetworkManagerr.request(EndPoints.fetchJobTypes, method: .get) { (response) in
            
            let jsonDecoder = JSONDecoder()
            let sectors = try? jsonDecoder.decode(AllSectorModel.self, from: response.data!)
            
            if let sectors = sectors {
                
                self.jobTypeList.append(contentsOf: sectors.data)
                
            }
        }
    }
    private func getPostDetail(jobId: Int) {
      
        let param:Parameters = [:]
        
        ApiCallerClass.getJobDetailByIdServiceFunc(usertoken:  LoggedUserDetails.shared.token!, jobId: jobId,para: param, success: { (dataRespose) in
            print(dataRespose)
            let data = dataRespose as? EditedJobRoot
            let error = data?.error
            
            self.view.isUserInteractionEnabled = true
            if error == false {
                for i in data!.data{
                    self.jobEdit=i
                }
                self.setUIData(modelSetter: self.jobEdit)
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.makeAlert(messageData:data?.message ?? "")
                self.view.isUserInteractionEnabled = true
            }
        })
        { (error) in
            IHProgressHUD.dismiss()
            print(error.localizedDescription)
            self.view.isUserInteractionEnabled = true
            
        }
        
    }
    private func updateJobAdPost(jobType: String,
                                 jobNature: String,
                                 jobSector: String,
                                 jobTitle: String,
                                 position: String,
                                 content: String,
                                 salary: String,
                                 location: String,
                                 UploadImage: UIImageView? = nil){
        
        
        let userDefaults = UserDefaults.standard
        let getUserData = BaseVC.GetUser()
        let getToken = userDefaults.value(forKey: "UserToken") as? String
        let userID = getUserData?.id
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myCurrentDate = formatter.string(from: currentDateTime)
        print(myCurrentDate)
        
        let param:Parameters = [
            "user_id" : userID!,
            "modified_by_id" : userID!,
            "status":"active",
            "job_title":jobTitle,
            "job_nature":jobNature,
            "job_sector":jobSector,
            "position":position,
            "content":content,
            "active_hours":Int("21")!,
            "location":location,
            "salary":Int(salary)!,
            "modified_datetime":myCurrentDate,
            "job_type":jobType
        ]
        print("param:\(param)\n\(getToken!)\n\(userID!)")
        IHProgressHUD.show()
        
        
        var imageData: Data?
        
        if let imageValue = UploadImage {
            let imageCompress =  imageValue.image!.jpegData(compressionQuality: 0.08)
            imageData = imageCompress
        }
        
        
        ApiCallerClass.apiMethodObj.updatePostJobAd(jobId:jobId!,usertoken:getToken!,
                                                    param: param,
                                                    imageData: imageData,
                                                    success: { (dataRespose) in
                                                        print(dataRespose)
                                                        let dataValue = dataRespose as? NSDictionary
                                                        print(dataRespose)
                                                        let dataMessage:String? = dataValue?.value(forKey: "message") as? String
                                                        DispatchQueue.global(qos: .default).async(execute: {
                                                            IHProgressHUD.dismiss()
                                                        })
                                                        if dataValue?["error"] as? Int == 0{
                                                            if self.delegate != nil{
                                                                self.delegate?.refreshJobDetail(checkForCall: true, JobIdDetail: self.jobId!)
                                                                print("*****Protocal call*****")
                                                                
                                                            }
                                                            else{
                                                                print("*****no Protocal call******")
                                                            }
                                                            self.makeAlert2(messageData: dataMessage ?? "Success")
                                                        }
                                                        else{
                                                            self.makeAlert(messageData:dataMessage ?? "Faild")
                                                            
                                                        }
        })
        { (error) in
            IHProgressHUD.dismiss()
            print(content)
            
            
        }
        
    }
    
    func setLayOut() {
        
        getSectors()
        getJobTypes()
        picker.delegate = self
        makeImageRound(view: profileImg,setBoader: true)
        getPostDetail(jobId: jobId!)
        pickerView =  UIPickerView()
        pickerView?.backgroundColor = .white
        picker.delegate = self
        pickerView?.showsSelectionIndicator = true
        pickerView!.delegate = self
        pickerView?.dataSource = self
        sectorTxt.delegate = self
        salaryTxt.delegate = self
        jobTypeTxt.delegate = self
        companyTxt.text = "\(LoggedUserDetails.shared.user?.companyName ?? "No Company")"
        companyTxt.isUserInteractionEnabled = false
        let tool = UIToolbar()
        tool.barStyle = .default
        tool.isTranslucent  = true
        tool.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        tool.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(donePicker))
         buttonCustomization(actionBtn: self.browseBtn,setClipsBound:false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
        tool.setItems([doneBtn,spaceBtn,cancel], animated: false)
        tool.isUserInteractionEnabled = true
        
        sectorTxt.inputView = pickerView
        jobTypeTxt.inputView = pickerView
        sectorTxt.inputAccessoryView = tool
        jobTypeTxt.inputAccessoryView = tool
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
    
    }

    func setUIData(modelSetter: EditedJob?) {
        if modelSetter != nil {
            getHours = "\(modelSetter?.activeHours ?? 12)"
            jobTitleTxt.text = modelSetter?.jobTitle
            sectorTxt.text = modelSetter?.jobSector
            companyTxt.text = modelSetter?.jobNature
            salaryTxt.text = "\(modelSetter?.salary ?? 0)"
            profileImg.sd_setImage(with: URL(string: (modelSetter?.jobImage)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
            descriptionTextField.text = modelSetter?.content
            positionTxt.text = modelSetter?.position
            locationTxt.text = modelSetter?.location
             jobTypeTxt.text = modelSetter?.jobType
        }
    }
    
    @objc func donePicker() {
        if checkPickerData == 0 {
            sectorTxt.resignFirstResponder()
        } else if checkPickerData == 1{
            jobTypeTxt.resignFirstResponder()
        }
    }
}

extension EditPostedJobVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imgData = NSData(data: (info[UIImagePickerController.InfoKey.originalImage] as! UIImage).jpegData(compressionQuality: 0.8)!)
        let imageSize: Int = imgData.count
        
        let image1 = info[(UIImagePickerController.InfoKey).originalImage] as? UIImage
        //chekcing size if its 4mb
        if  imageSize <= 4194304 {
            self.profileImg.contentMode = .scaleAspectFill
            self.sizeCheck = true
            self.profileImg.image = image1

        } else {
            self.sizeCheck = false
            makeAlert(messageData: "Image File must be less than equal to 4 MB")
        }

        dismiss(animated: true, completion: nil)
    }
}
