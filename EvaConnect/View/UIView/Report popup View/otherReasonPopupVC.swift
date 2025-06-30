//
//  otherReasonPopupVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 03/06/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class otherReasonPopupVC: UIViewController,XIBed {

    @IBOutlet weak var mainUIView: UIView!
    @IBOutlet weak var reasonForReport: UILabel!
    
    @IBOutlet weak var reportBtn: UIButton!
//    @IBOutlet weak var textViewUIView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var reasonsView: UIView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    var reason = ""
    var userId = 0
    var postId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        popupView(uiView: mainUIView)
        self.textView.delegate = self
    }
    
    @IBAction func reportBtnTapped(_ sender: UIButton) {
        guard textView.text != "" else {
            presentAlert("Empty", "reason can not be blank.")
            return
        }
        sendReport()
    }
    
    func sendReport() {
        showActivity()
        var parameterss: AFParameters  = [:]
        parameterss = ["reason": textView.text ?? ""]
            
                      /*  "tag_name": textView.text ?? "",
                       "user_id": self.userId,
                       "post_id": self.postId] */

        NetworkManagerr.request(EndPoints.createReport, method: .post, parameters: parameterss) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error) {
                    if newsRoot.error {
                        self.presentAlert("Failure", newsRoot.message, nil)
                    } else {
                        self.presentAlert("Success", "Report Sent") {
                            self.dismiss(animated: true)
                        }
                    }
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }

}


extension otherReasonPopupVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLbl.isHidden = true
        adjustTextViewHeight()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""//Constants.Chat.composeMessage
            textView.textColor = UIColor.lightGray
            self.placeholderLbl.isHidden = false
        } else {
            self.placeholderLbl.isHidden = true
        }
        
    }
    
    func adjustTextViewHeight() {
        // Set a maximum height if needed
        let maxHeight: CGFloat = 112.0
        
        // Calculate the new height based on the content size
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: maxHeight))
        
        // Update the text view's height constraint or frame
        textView.constraints.forEach {
            if $0.firstAttribute == .height {
                // Adjust the height constraint
                $0.constant = min(newSize.height, maxHeight)
            }
        }
        
        // Optionally, scroll to the bottom to keep the latest text visible
        let bottomOffset = CGPoint(x: 0, y: max(textView.contentSize.height - textView.bounds.height, 0))
        textView.setContentOffset(bottomOffset, animated: false)
    }
    
    
}
