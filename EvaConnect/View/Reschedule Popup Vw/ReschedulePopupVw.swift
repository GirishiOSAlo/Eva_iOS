//
//  ReschedulePopupVw.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 29/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Lottie

class ReschedulePopupVw: UIViewController, XIBed {

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet var baseViewCollection: [UIView]!
    @IBOutlet var detilsTitleLbllCollection: [UILabel]!
    @IBOutlet weak var rescheduleBtn: UIButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var starttimeTextField: UITextField!
    @IBOutlet weak var endtimeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    var animationView: LottieAnimationView!
    
    var placeholderLabel : UILabel!
    var datePicker = UIDatePicker()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    var meetingID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.roundCorners([.topRight, .topLeft], radius: 35.0)
    }
    
    func setupUI() {
        self.successPopupVw.isHidden = true
        self.setupTextView()
        headingLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        rescheduleBtn.cornerRadius = 14.0
        for baseView in baseViewCollection {
            baseView.applyBorderWithRadius(color: UIColor(hex: "#C3CCDF"), value: 1, radius: 8)
        }
        for lbl in detilsTitleLbllCollection {
            lbl.font = UIFont(name: Myfonts.bold, size: 14.0)
        }
        
        self.dateTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.starttimeTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.endtimeTextField.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.noteTextView.font = UIFont(name: Myfonts.regular, size: 14.0)
    }
    
    func setupTextView() {
        noteTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write you reason here..."
        placeholderLabel.font = UIFont(name: Myfonts.regular, size: 14.0)
        placeholderLabel.sizeToFit()
        noteTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(hex: "#8C8C8C", alpha: 1.0)
        placeholderLabel.isHidden = !noteTextView.text.isEmpty
    }
    
    func addAnimation(){
        animationView = LottieAnimationView(name: "successLottie.json")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationContainerView.addSubview(animationView)
        animationView.play()
    }
    @IBAction func onSuccessOkBtn(_ sender: UIButton) {
        self.successPopupVw.isHidden = true
        self.animationView.stop()
        self.dismiss(animated: true)
    }

    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onDatePickerBtnTap(_ sender: UIButton) {
        datePickerSet()
        self.dateTextField.becomeFirstResponder()
    }
    
    @IBAction func onStartTimePickerBtnTap(_ sender: UIButton) {
        startTimePickerSet()
        self.starttimeTextField.becomeFirstResponder()
    }
    
    @IBAction func onEndTimePickerBtnTap(_ sender: UIButton) {
        endTimePickerSet()
        self.endtimeTextField.becomeFirstResponder()
    }
    
    @IBAction func onRescheduleBtnTap(_ sender: UIButton) {
        if self.dateTextField.text == "" {
            self.presentAlert("Please select a date.")
        }
        else if self.starttimeTextField.text == "" {
            self.presentAlert("Please select a start time.")
        }
        else if self.endtimeTextField.text == "" {
            self.presentAlert("Please select an end time.")
        }
        else {
            self.rescheduleMeeting()
        }
    }
}

extension ReschedulePopupVw {
    func rescheduleMeeting() {
        let url = EndPoints.rescheduleEventMeeting
        let parameters = [
            "rescheduleMeetingid": "\(self.meetingID)",
            "date": self.dateTextField.text ?? "",
            "starttime": self.starttimeTextField.text ?? "",
            "endtime": self.endtimeTextField.text ?? "",
            "description": self.noteTextView.text ?? "" ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let rescheduleRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                if !(rescheduleRoot.error) {
                    print("Success")
                    self.successPopupVw.isHidden = false
                    self.titlePopupLbl.text = rescheduleRoot.message
                    self.addAnimation()
                } else {
                    print("Error :: \(rescheduleRoot.message)")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

extension ReschedulePopupVw {
    func datePickerSet() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.minimumDate = Date()//.addingTimeInterval(168 * 60 * 60)  //Next to 7 day select...

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        self.dateTextField.inputView = datePicker
        self.dateTextField.inputAccessoryView = toolbar
    }
    
    func startTimePickerSet() {
        startTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            startTimePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        startTimePicker.minimumDate = Date()

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        self.starttimeTextField.inputView = startTimePicker
        self.starttimeTextField.inputAccessoryView = toolbar
    }
    
    func endTimePickerSet() {
        endTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            endTimePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        endTimePicker.minimumDate = Date()

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEndTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.backgroundColor = UIColor(hex: "#F8F6F8")
        toolbar.tintColor = UIColor(hex: "#000000")

        self.endtimeTextField.inputView = endTimePicker
        self.endtimeTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneStartDatePicker() {
        self.dateTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func doneStartTimePicker() {
        self.starttimeTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        self.starttimeTextField.text = formatter.string(from: startTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func doneEndTimePicker() {
        self.endtimeTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        self.endtimeTextField.text = formatter.string(from: endTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
}

extension ReschedulePopupVw : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
