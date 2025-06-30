//
//  EditJobUserPostV2.swift
//  EvaConnect
//
//  Created by Metis on 11/03/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire

@IBDesignable
class JobApplyVC: BaseVC {
    
    //MARK: Outlets
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet var boderView: UIView!
    @IBOutlet weak var uploadBtn: UIButton!
    
    //MARK: VARIABLES
    // weak var delegate : refreshJobDetailCall? = nil
    weak var delegate: RefreshUpdateable?
    var jobId = 0
    var jobDetail: ShowJobDetailModel!
    var sizeCheck = false
    var cvURL: URL?
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: IB Actions
extension JobApplyVC {
    
    @IBAction func browseFile(_ sender: Any) {
        //GotoJobApplyVC()
        openFile()
    }
    
    @IBAction func applyJob(_ sender: Any) {
        
        //GotoJobApplyVC()
        if fileNameLbl.text != "file.pdf" && descriptionTxt.text != "" && descriptionTxt.text != Constants.PlaceHolders.typeHere {
            applyForJob()
        } else {
            makeAlert(messageData: "Please fill all fields")
        }
    }
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        delegate?.refresh(homeStatus: true)
        navigationController?.popViewController(animated: true)
    }
}

extension JobApplyVC {

    private func applyForJob(){
        
        let parameters: Parameters = [ "user_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                       "created_by_id" : myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                       "status": "active",
                                       "job_id": jobDetail.id,
                                       "content": descriptionTxt.text!]
        
        self.showActivity()
        Alamofire.upload(multipartFormData: { (multiFormData) in
            
            for (key, value) in parameters {
                multiFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentsDirectory = directory.appendingPathComponent("EvaDocuments")
            
            let sandboxFileUrl = documentsDirectory.appendingPathComponent(self.cvURL!.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: sandboxFileUrl.path) {
                
                let pdfData = try? Data(contentsOf: sandboxFileUrl)
                multiFormData.append(pdfData!, withName: "application_attachment", fileName: self.cvURL!.lastPathComponent, mimeType: "pdf")
                
            } else {
                print("file doesn't exist there")
            }
            
        }, to: EndPoints.applyForJob, method: .post, headers: SharedHeaders.headers) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("uploading \(progress)")
                })
                
                upload.responseJSON { (response) in
                    self.hideActivity()
                    if response.result.isSuccess {
                        let jsonDecoder = JSONDecoder()
                        let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from: response.data!)
                        
                        if let genericResponse = genericResponse, !genericResponse.error {
                            
                             self.makeAlert2(messageData: "Applied Successfully")
                        }
                        else {
                            self.presentAlert("Failure", nil, response.result.error)
                        }
                    }
                }
                
            case .failure(let error):
                print (error.localizedDescription)
            }
        }
    }
}

//MARK: Helper Methods

extension JobApplyVC {

    func setLayOut() {
        descriptionTxt.delegate = self
        applyBtn.titleLabel?.font = UIFont(defaultFontStyle: .bold, size: 12.0)
        applyBtn.layer.cornerRadius = applyBtn.frame.height / 2
        applyBtn.applyGradient(colors: [AppColors.blueHigherGradient.cgColor, AppColors.lowerGradient.cgColor, AppColors.higherGradient.cgColor, AppColors.lowestGradient.cgColor])
        //applyBtn.roundOnly()
        applyBtn.layer.masksToBounds = true
        //setButton(view: applyBtn,ConnerByHeight: true)
        makeImageRound(view: postImage,setBoader: true)
        setUIData(jobDetail: jobDetail!)
        boderView.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
        uploadBtn.makeRoundView(backGroundColor: .white, boderColor: Constants.AppColorLiteral.signUpNew, boderValue: 1.0)
    }
    
    func setUIData(jobDetail: ShowJobDetailModel) {
        titleLbl.text = jobDetail.jobNature
        positionLbl.text = jobDetail.jobTitle
        postImage.sd_setImage(with: URL(string: (jobDetail.jobImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
    }
    
    func openFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
}

extension JobApplyVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text.isEmpty ||  textView.text == "" {
            textView.text = Constants.PlaceHolders.typeHere
        }
    }
}

extension JobApplyVC : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first!
        // Construct a URL with desired folder name
        let folderURL = documentDirectory.appendingPathComponent("EvaDocuments")
        // If folder URL does not exist, create it
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.createDirectory(atPath: folderURL.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let savePdfUrl = folderURL.appendingPathComponent(url.lastPathComponent)
        
        do { try FileManager.default.moveItem(at: url, to: savePdfUrl) }
        catch {
            print("error")
        }
        
        fileNameLbl.text = url.lastPathComponent
        cvURL = url
    }
}
