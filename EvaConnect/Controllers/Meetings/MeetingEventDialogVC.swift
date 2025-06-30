//
//  MeetingEventDialogVC.swift
//  EvaConnect
//
//  Created by usama on 06/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol DismissViewDelegate: NSObject {
    func dismissView()
}

protocol MeetingEventDialogDelegate: NSObject {
    func eventDialogDismiss(calendar: CalendarModelList)
}

class MeetingEventDialogVC: UIViewController {
    
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var dialog: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var eventStackView: UIStackView!
    @IBOutlet weak var details: UITextView!

    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var buttonImage: UIImageView!

    var calendarObject: CalendarModelList!
    var dismissGesture: UITapGestureRecognizer!
    var delegate: MeetingEventDialogDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
    
}

extension MeetingEventDialogVC {
    
    func initUI() {
        
        dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        dismissGesture.delegate = self
        view.addGestureRecognizer(dismissGesture)
        
        if calendarObject.objectType == .meeting {
            eventStackView.isHidden = true
            viewButton.setBackgroundImage(UIImage(named: "ic_green_button"), for: .normal)
            createdBy.isHidden = true
            viewButton.setTitle("View Meeting", for: .normal)
        } else if calendarObject.objectType == .note {
            let date = calendarObject.objectDetails?.occurrenceDate?.standardDate(isUTC: true) ?? ""
            let time = calendarObject.objectDetails?.occurrenceTime?.in12HourFormat(isUTC: true) ?? ""
            dateTime.text = "\(date) \(time)"
            name.text = calendarObject.objectDetails?.title
//            createdBy.text = "Created by \(calendarObject.objectDetails?.user?.fullName ?? "")"
            locationStackView.isHidden = true
            viewButton.setBackgroundImage(UIImage(named: "ic_blue_btn"), for: .normal)
            viewButton.setTitle("View Note", for: .normal)
        } else {
            let startDate = calendarObject.objectDetails?.startDate?.standardDate(isUTC: true) ?? ""
            let startTime = calendarObject.objectDetails?.startTime?.in12HourFormat(isUTC: true) ?? ""
            
//            let endDate = calendarObject.objectDetails?.endDate?.standardDate(isUTC: true) ?? ""
//            let endTime = calendarObject.objectDetails?.endTime?.in12HourFormat(isUTC: true) ?? ""
            
            dateTime.text = "\(startDate) \(startTime)"
            name.text = calendarObject.objectDetails?.name
//            createdBy.text = "Created by \(calendarObject.objectDetails?.user?.fullName ?? "")"
            viewButton.setBackgroundImage(UIImage(named: "ic_red_btn"), for: .normal)
            viewButton.setTitle("View Event", for: .normal)
        }
        
        name.text = calendarObject.objectType == .note ? calendarObject.objectDetails?.title.stringValue : calendarObject.objectDetails?.name.stringValue
        location.text = calendarObject.objectDetails?.address.stringValue
        details.text = calendarObject.objectType == .note ? calendarObject.objectDetails?.details.stringValue : calendarObject.objectDetails?.content.stringValue
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {
         dismiss(animated: true, completion: nil)
     }
    
    @IBAction func view_touchUpInside(_ sender: UIButton) {
        definesPresentationContext = true
        dismiss(animated: true) { self.delegate?.eventDialogDismiss(calendar: self.calendarObject) }
    }
}

extension MeetingEventDialogVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: dialog) == true {
            return false
        }
        return true
    }
}

extension MeetingEventDialogVC: DismissViewDelegate {
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
