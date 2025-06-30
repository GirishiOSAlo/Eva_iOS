//
//  EventDelegateSearchPopupVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 12/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

protocol EventDelegateFilterDismiss: AnyObject {
    func eventDelegateFilterData(filterArr: [EventDelegateFilterList], isFilter: Bool)
}

class EventDelegateSearchPopupVC: UIViewController {
    
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var mainView: UIView!
    var eventId = 0
    @IBOutlet weak var baseView4: UIView!
    @IBOutlet weak var regionTextField: UITextField!
    var region = ""
    
    @IBOutlet weak var baseView3: UIView!
    @IBOutlet weak var businessSectorTextField: UITextField!
    var businessSector = ""
    //    var jobSectorList = ["Commercial Aviation", "General-Business Aviation", "Air Cargo"]
    
    @IBOutlet weak var baseView2: UIView!
    @IBOutlet weak var jobTitleTextField: UITextField!
    
    @IBOutlet weak var baseView1: UIView!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var searchFiltersBtn: UIButton!
    var eventDelegateFilterArr: [EventDelegateFilterList] = []
    weak var EventDelegateFilterDismissDelegate: EventDelegateFilterDismiss?
    
    var completion: ((Int) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    
    func setupUI(){
        popupView(uiView: mainView)
        
        baseView1.applyBorderWithRadius()
        baseView2.applyBorderWithRadius()
        baseView3.applyBorderWithRadius()
        baseView4.applyBorderWithRadius()
        self.searchFiltersBtn.layer.cornerRadius = self.searchFiltersBtn.frame.size.height/2
        
        self.companyNameTextField.delegate = self
        self.jobTitleTextField.delegate = self
        
        if self.businessSector.elementsEqual("") {
            businessSectorTextField.text = ""
        } else {
            businessSectorTextField.text = self.businessSector
        }
        
        if self.region.elementsEqual("") {
            regionTextField.text = ""
        } else {
            regionTextField.text = region
        }
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDidTap))
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(dismissTapGesture)
        
    }
    
    @objc func dismissDidTap() {
        self.dismiss(animated: true)
    }
    
    @IBAction func onSearchFiltersBtnTapped(_ sender: UIButton) {
        //self.dismiss(animated: true)
        if (self.companyNameTextField.text == "") && (self.jobTitleTextField.text == "") && (self.businessSectorTextField.text == "") && (self.regionTextField.text == "") {
            presentAlert("Alert", "Please add/select atleast one value")
        }else {
            fetchFilterData()
        }
    }
    
    @IBAction func onBusinessSectorSelect(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.completion?(0)
    }
    
    @IBAction func onRegionSelect(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.completion?(1)
    }
    
    @IBAction func onClearFilterBtnTapped(_ sender: UIButton) {
        self.companyNameTextField.text = ""
        self.jobTitleTextField.text = ""
        self.businessSectorTextField.text = ""
        self.regionTextField.text = ""
        self.businessSector = ""
        self.region = ""
        NotificationCenter.default.post(name: NSNotification.Name("ClearData"), object: nil, userInfo: nil)
    }
    
    func fetchFilterData() {
        let parameters: AFParameters = [ "event_id": self.eventId, "job_title":self.jobTitleTextField.text ?? "", "company_name":self.companyNameTextField.text ?? "", "business_sector":self.businessSectorTextField.text ?? "", "region":self.regionTextField.text ?? ""]
        showActivity()
        NetworkManagerr.request(EndPoints.eventFilter, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let decoder = JSONDecoder()
                let eventDelegate = try decoder.decode(EventDelegateFilterRes.self, from: response.data!)
                self.eventDelegateFilterArr = eventDelegate.data ?? []
                
                print("Event Delegate Filter List :: \(self.eventDelegateFilterArr)")
                
                self.dismiss(animated: true) {
                    self.EventDelegateFilterDismissDelegate?.eventDelegateFilterData(filterArr: self.eventDelegateFilterArr, isFilter: true)
                }

            } catch {
                print(error)
            }
        }
    }
}

extension EventDelegateSearchPopupVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if companyNameTextField.isFirstResponder {
            print("Company Name TextField End.")
        }
        else if jobTitleTextField.isFirstResponder {
            print("Job Title TextField End.")
        }
    }
}
