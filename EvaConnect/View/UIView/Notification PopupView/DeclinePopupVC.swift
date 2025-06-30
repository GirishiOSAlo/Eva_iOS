//
//  DeclinePopupVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 16/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class DeclinePopupVC: UIViewController,XIBed {

    @IBOutlet weak var mainUIView: UIView!
    @IBOutlet weak var reasonForDecline: UILabel!
    
    @IBOutlet weak var declineMsg: UIButton!
    @IBOutlet weak var reason1Btn: UIButton!
    @IBOutlet weak var reason2Btn: UIButton!
    @IBOutlet weak var reason3Btn: UIButton!
    @IBOutlet weak var otherReason: UIButton!
    @IBOutlet weak var textViewUIView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var reasonsView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    var reason = ""
    var meetingID = 0
    var reason1 = false
    var reason2 = false
    var reason3 = false
    var completion: (()->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView(uiView: mainUIView)
        self.textView.delegate = self
        reasonsView.isHidden = false
        otherView.isHidden = true
    }

    @IBAction func reason1Tapped(_ sender: UIButton) {
        reason1.toggle()
        if reason1 {
            reason2Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
            reason3Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
            reason1Btn.setImage(UIImage(named: "fillRadioBtn"), for: .normal)
            self.reason = "Sorry, unfortunately I am busy"
        } else {
            reason1Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
        }
    }
    
    @IBAction func reason2Tapped(_ sender: UIButton) {
        reason2.toggle()
        if reason2 {
            reason1Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
            reason3Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
            reason2Btn.setImage(UIImage(named: "fillRadioBtn"), for: .normal)
            self.reason = "This is not my field of expertise"
        } else {
            reason2Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
        }
        
    }
    
    @IBAction func reason3Tapped(_ sender: UIButton) {
        reason3.toggle()
        if reason3 {
            reason1Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
            reason2Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
            reason3Btn.setImage(UIImage(named: "fillRadioBtn"), for: .normal)
            self.reason = "Sorry, this time isn’t convenient"
        } else {
            reason3Btn.setImage(UIImage(named: "emptyRadioBtn"), for: .normal)
            self.reason = ""
        }
        
    }
    
    @IBAction func reasonOtherTapped(_ sender: UIButton) {
        reasonsView.isHidden = true
        otherView.isHidden = false
    }
    
    @IBAction func declineMeetingTapped(_ sender: UIButton) {
        if reason != "" || textView.text != "" {
            self.declineMeeting()
        } else {
            presentAlert("Alert", "Please add reason for decline")
        }
    }
}

extension DeclinePopupVC: UITextViewDelegate {
    
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

// MARK: API Calls
extension DeclinePopupVC {
    func declineMeeting() {
        if self.reason == "" {
            self.reason = self.textView.text
        }
        let parameters = ["filter": "decline",
                          "attending_user": "\(LoggedUserDetails.shared.user?.id ?? 0)",
                          "meeting_id": self.meetingID,
                          "reason": self.reason] as [String : Any]
        
        NetworkManagerr.request(EndPoints.acceptMeetingPopup, method: .post, parameters: parameters) { (response) in
            if response.result.isSuccess {
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let meetingRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if meetingRoot.error == false {
                    
                        self.showToast(message: "Invite Declined")
                        self.dismiss(animated: true)
                        self.completion?()
                        print(meetingRoot.message )
                    } else {
                        print(meetingRoot.message )
                    }
                    print(meetingRoot.message )
                } catch {
                    //
                }
            }
        }
    }
}
