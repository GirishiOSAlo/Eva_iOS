//
//  UploadCVVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 07/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import MobileCoreServices

class UploadCVVC: UIViewController {

    weak var delegate: SelectedResumePassingDelegate?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var HeadingLable: UILabel!
    
    @IBOutlet weak var uploadCVBtn: UIButton!
    
    @IBOutlet weak var preCVLable: UILabel!
    @IBOutlet weak var cvCollectionView: UICollectionView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var emptyDataLbl: UILabel!
    
    var resumeList: [ResumeData] = [] {
        didSet {
            self.cvCollectionView.reloadData()
        }
    }
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        fetchResumeData()
    }
    
    func setUpView(){
        self.emptyDataLbl.isHidden = true
        uploadCVBtn.layer.cornerRadius = 14
        uploadCVBtn.layer.borderWidth = 1
        uploadCVBtn.layer.borderColor = AppColors.appBlue.cgColor
        uploadCVBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        
        HeadingLable.font = UIFont(name: Myfonts.bold, size: 16)
        preCVLable.font = UIFont(name: Myfonts.semiBold, size: 18)
        
        selectBtn.layer.cornerRadius = 14
        cvCollectionView.registerNib(cellNib: PreviousCVCell.self)
        cvCollectionView.delegate = self
        cvCollectionView.dataSource = self
    }
    
    func selectBtnEnable() {
        self.selectBtn.isUserInteractionEnabled = true
        self.selectBtn.backgroundColor = UIColor(hex: "#4D76CD", alpha: 1.0)
    }
    
    func selectBtnDisable() {
        self.selectBtn.isUserInteractionEnabled = false
        self.selectBtn.backgroundColor = UIColor(hex: "#4D76CD", alpha: 0.5)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadCVBtnTapped(_ sender: UIButton) {
        openFile()
    }
    
    @IBAction func selectBtnTapped(_ sender: UIButton) {
        if self.resumeList.count == 0 {
            self.selectBtnDisable()
        } else {
            let selectedResume = self.resumeList[self.selectedIndex]
            delegate?.didPassData(selectedResume)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func deleteResume(sender: UIButton) {
        print("Delete Resume")
        let resume = self.resumeList[sender.tag]
        self.deleteResume(id: resume.id ?? 0)
    }
    @objc func downloadResume(sender: UIButton) {
        print("Delete Resume")
        let resume = self.resumeList[sender.tag]
        let urlString = resume.resumeFile ?? ""
        
        // Encode the URL to handle spaces and special characters
        if let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL")
        }
    }
}

extension UploadCVVC: UIDocumentPickerDelegate {
    private func openFile() {
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet, kUTTypeCompositeContent]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        let cvDocumentURL = url
//        let fileName = url.lastPathComponent
        self.uploadResume(fileURL: url)
    }
    
    func uploadResume(fileURL: URL) {
        do {
            let fileData = try Data(contentsOf: fileURL) // <-- throwable
            let sizeMB = Double(fileData.count) / (1024.0 * 1024.0)
            
            if sizeMB > 5 {
                print("❌ Resume PDF File Too Large")
                self.presentAlert("File Too Large", "Your document is \(String(format: "%.2f", sizeMB)) MB. Maximum allowed size is less than 5 MB.")
                return
            }
            
            if let base64Doc = encodeToBase64(reqURL: fileURL),
               let decodedData = Data(base64Encoded: base64Doc) {
                
                let fileName = fileURL.lastPathComponent
                uploadResumeWithFile(fileData: decodedData, fileName: fileName)
            }
        } catch {
            print("Error loading file data: \(error)")
        }
    }

    
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
    func encodeToBase64(reqURL: URL) -> String? {
        showActivity()
        if FileManager.default.fileExists(atPath: reqURL.path) {
            // The file exists, proceed with encoding
            do {
                let myData = try Data(contentsOf: reqURL)
                let base64String = myData.base64EncodedString()
                return base64String
            } catch {
                print("Error encoding PDF Resume to base64: \(error)")
                return nil
            }
        } else {
            print("File does not exist at: \(reqURL.path)")
            return nil
        }
    }
    
    func uploadResumeWithFile(fileData: Data, fileName: String) {
        let url = URL(string: EndPoints.resumeUpload)!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let bearerToken = myUserDefaults.token // Replace with actual token
           request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        var body = Data()

        // Add file part
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"resume_file\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: application/pdf\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")

        // End boundary
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        showActivity()

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.hideActivity()
            }

            if let error = error {
                print("Upload error: \(error)")
                return
            }

            guard let data = data else {
                print("No response data")
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(GenericResponse.self, from: data)
                DispatchQueue.main.async {
                    if !root.error {
                        let alert = UIAlertController(title: "Success",
                                                      message: "Resume has been Uploaded successfully.",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            self.navigationController?.popViewController(animated: true)
                            self.fetchResumeData()
                        })
                        self.present(alert, animated: true)
                    } else {
                        self.presentAlert("Failure", root.message, nil)
                    }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }

}

extension UploadCVVC {
    func fetchResumeData() {
        showActivity()
        let url = "\(EndPoints.resumeList)"
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                let jsonDecoder = JSONDecoder()
                let resumeData = try! jsonDecoder.decode(ResumeDataModel.self, from:response.data!)
                if !(resumeData.error ?? false) {
                    self.resumeList = resumeData.data ?? []
                    if self.resumeList.count > 0 {
                        self.emptyDataLbl.isHidden = true
                        self.selectBtnEnable()
                        self.selectBtn.isEnabled = true
                    } else {
                        self.emptyDataLbl.isHidden = false
                        self.selectBtnDisable()
                    }
                } else {
                    self.presentAlert("Error", nil, response.error)
                }
            }
        }
    }
    
    func uploadResume() {
        let parameters = [
            "resume_file": ""
        ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(EndPoints.resumeUpload,method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if !(root.error) {
                    let alert = UIAlertController(title: "Success",
                                                  message: "Resume has been Uploaded successfully.",
                                                  preferredStyle: .alert
                    )
                    let okButton = UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    self.fetchResumeData()
                } else {
                    self.presentAlert("Failure", root.message, nil)
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func deleteResume(id: Int) {
        showActivity()
        var params: [String:Any] = [:]
        let url = "\(EndPoints.deleteResume)\(id)"
        NetworkManagerr.request(url, method: .delete, parameters: params) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let root = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                
                if !(root.error) {
                    let alert = UIAlertController(title: "Success",
                                                  message: "Resume has been deleted successfully.",
                                                  preferredStyle: .alert
                    )
                    let okButton = UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                        self.fetchResumeData()
                    }
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.presentAlert("Failure", root.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

extension UploadCVVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resumeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cvCollectionView.dequeueReusableCell(withReuseIdentifier: PreviousCVCell.ReuseId, for: indexPath) as! PreviousCVCell
        
        let resume = self.resumeList[indexPath.row]
        cell.uiData(dataMaper: resume)
        
        if indexPath.row == self.selectedIndex {
            cell.outerView.backgroundColor = UIColor(hex: "#F4F6FA")
            cell.outerView.layer.borderColor = AppColors.appBlue.cgColor
        } else {
            cell.outerView.backgroundColor = UIColor(hex: "#FFFFFF")
            cell.outerView.layer.borderColor = UIColor(hex: "#C3CCDF").cgColor
        }
        
        cell.downloadCVBtn.tag = indexPath.row
        cell.downloadCVBtn.addTarget(self, action: #selector(downloadResume(sender:)), for: .touchUpInside)
        cell.deleteCVBtn.tag = indexPath.row
        cell.deleteCVBtn.addTarget(self, action: #selector(deleteResume(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.cvCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.cvCollectionView.frame.size.width), height: 81)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
