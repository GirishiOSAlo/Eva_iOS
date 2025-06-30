//
//  CreateNoteVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/6/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class CreateNoteVC: UIViewController {

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var remindBtn: UIButton!
    @IBOutlet weak var detailTxt: UITextView!
    @IBOutlet weak var timeTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    lazy var timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 5
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private var isNotify = 0
//    {
//        didSet {
//            remindBtn.setTitle(isNotify ? "   Reminder Added   " : "Remind Me", for: .normal)
//        }
//    }
    
    var note:  CalendarModelList? = nil
    private var utcDate: String = ""
    private var utcTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.shared.enable.toggle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.shared.enable.toggle()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func remindMeBtnTapped(_ sender: Any) { isNotify.toggle() }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        if titleTxt.text?.trim.isEmpty ?? true {
            presentAlert("Alert", "Please Enter Title")
//            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please Enter Title")
        } else if dateTxt.text?.trim.isEmpty ?? true {
            presentAlert("Alert", "Please Enter Date")
//            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please Enter Date")
        } else if timeTxt.text?.trim.isEmpty ?? true {
            presentAlert("Alert", "Please Enter Time")
//            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please Enter Time")
        } else if detailTxt.text?.trim.isEmpty ?? true {
            presentAlert("Alert", "Please Enter Detail")
//            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please Enter Detail")
        } else {
            createEditNote()
        }
    }
}

extension CreateNoteVC {
    
    private func initUI() {
        let toolBar = toolBarAccessory()
        dateTxt.inputView = datePicker
        dateTxt.inputAccessoryView = toolBar
        timeTxt.inputView = timePicker
        timeTxt.inputAccessoryView = toolBar
        detailTxt.delegate = self
        detailTxt.textColor = AppColors.lightBg
        detailTxt.text = "Describe your Note..."
        doneBtn.layer.cornerRadius = 24
        
        if let note = note {
            utcDate = note.objectDetails?.occurrenceDate.stringValue ?? ""
            utcTime = note.objectDetails?.occurrenceTime.stringValue ?? ""
            titleTxt.text = note.objectDetails?.title.stringValue
            dateTxt.text = note.objectDetails?.occurrenceDate.stringValue
            timeTxt.text = note.objectDetails?.occurrenceTime.stringValue
            detailTxt.text = note.objectDetails?.details.stringValue
            doneBtn.setTitle("Update", for: .normal)
            
        }
    }
    
    func toolBarAccessory() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
}

extension CreateNoteVC {
    
    @objc func onClickDoneButton() {
        if dateTxt.isFirstResponder {
            dateTxt.text = datePicker.date.toString(formatter: .apiBody)
            utcDate = datePicker.date.toString(formatter: .apiBodyUTC)
            dateTxt.resignFirstResponder()
        } else if timeTxt.isFirstResponder {
            timeTxt.text = timePicker.date.toString(formatter: .timeOnly)
            utcTime = timePicker.date.toString(formatter: .timeOnlyUTC).in24hourFormat()
            timeTxt.resignFirstResponder()
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        dateTxt.text = sender.date.toString(formatter: .apiBody)
    }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        timeTxt.text = sender.date.toString(formatter: .timeOnly)
    }
    
}

extension CreateNoteVC {
    
    private func createEditNote() {
        var params: Parameters = ["occurrence_date": utcDate, "user_id": note?.userID ?? myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                  "details": detailTxt.text!.trim, "created_by_id": note?.userID ?? myUserDefaults.userId, //LoggedUserDetails.shared.user!.id,
                                  "title": titleTxt.text!.trim, "is_notify": isNotify, "occurrence_time": utcTime, "status": "active"]
        let endPoint = EndPoints.createNote
        if let note = note {
            params["id"] = note.objectID ?? note.id
            params["modified_by_id"] = myUserDefaults.userId //LoggedUserDetails.shared.user!.id
            // endPoint = "\(endPoint)\(params["id"]!)/"
        }
        
        let method: HTTPMethod = note == nil ? .post : .patch
        showActivity()
        doneBtn.isUserInteractionEnabled.toggle()
        
        NetworkManagerr.request(endPoint, method: method, parameters: params) { [weak self] (result: Result<Wrapper<[String]>>) in
            guard let self = self else { return }
            self.hideActivity()
            self.doneBtn.isUserInteractionEnabled.toggle()
            switch result {
            case .success(let value):
                self.presentAlert(value.error ? "Error" : "Success", value.message.capitalized, nil) {
                    if !value.error {
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                self.presentAlert("Error", nil, error)
            }
        }
    }
}

extension CreateNoteVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == AppColors.lightBg {
            textView.text = nil
            textView.textColor = AppColors.textColor2
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= 100 {
            detailTxt.isScrollEnabled = true
        }
        else {
            textView.frame.size.height = textView.contentSize.height
            detailTxt.isScrollEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your Note..."
            textView.textColor = AppColors.lightBg
        }
    }
}
