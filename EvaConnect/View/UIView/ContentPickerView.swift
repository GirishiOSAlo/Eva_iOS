//
//  ContentPickerView.swift
//  Personal Project
//
//  Created by Muhammad Salman Zafar on 29/01/2019.
//  Copyright © 2019 Muhammad Salman Zafar. All rights reserved.
//

import UIKit

class ContentPickerView: NSObject {
    
    private let contentView : UIView!
    private let datePickerView = UIDatePicker()
    private let pickerView = UIPickerView()
    let doneBtn = UIButton()
    private let mainView = UIView()
    private let greyView = UIView()
    private let titleLabel = UILabel()
    private var bottomConstraint: NSLayoutConstraint!
    private var mainViewHeight: NSLayoutConstraint!
    private var pickerValues = [String]()
    
    var isShowing = false {
        didSet { show() }
    }
    
    var title: String = "" {
        didSet { titleLabel.text = title }
    }
    
    var isDarkMode: Bool = false {
        didSet {
            mainView.backgroundColor = isDarkMode ? #colorLiteral(red: 0.168627451, green: 0.2039215686, blue: 0.2549019608, alpha: 1) : .white
            contentView.backgroundColor = isDarkMode ? #colorLiteral(red: 0.168627451, green: 0.2039215686, blue: 0.2549019608, alpha: 1) : .white
            titleLabel.textColor = isDarkMode ? .white : .black
        }
    }
    
    var showDatePicker: Bool = false {
        didSet {
            datePickerView.isHidden = !showDatePicker
            pickerView.isHidden = showDatePicker
            datePickerView.isUserInteractionEnabled = showDatePicker
            pickerView.isUserInteractionEnabled = !showDatePicker
            
        }
    }
    
    var contentHeight: CGFloat = 0 {
        didSet {
            mainViewHeight.constant = contentHeight
        }
    }
    
    init(contentView: UIView, pickerValues: [String]) {
        self.contentView = contentView
        self.pickerValues = pickerValues
        super.init()
        
        setContentView()
        setMainView()
        setTitleLabelView()
        setDatePicker()
        setPickerView()
        setDoneButton()
    }
    
    private func setContentView() {
        
        greyView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2965539384)
        greyView.alpha = 0
        greyView.translatesAutoresizingMaskIntoConstraints = false
        greyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(greyViewTapped)))
        contentView.addSubview(greyView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: greyView.topAnchor),
            contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: greyView.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: greyView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: greyView.trailingAnchor)
        ])
    }
    
    private func setMainView() {
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .white
        contentView.addSubview(mainView)
        
        bottomConstraint = contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.bottomAnchor,
                                                                                   constant: -1 * contentView.frame.width * 10)
        mainViewHeight = mainView.heightAnchor.constraint(equalToConstant: 350)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            bottomConstraint,
            mainViewHeight
        ])
    }
    
    private func setTitleLabelView() {
        
        titleLabel.font = UIFont(name: "Avenir-Book", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            mainView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    private func setDatePicker() {
        
        //1919 to 2006
        if #available(iOS 13.4, *) { datePickerView.preferredDatePickerStyle = .wheels }
        datePickerView.datePickerMode = .date
        
        datePickerView.minimumDate = Date(timeIntervalSince1970: -1609478940.0)
        datePickerView.maximumDate = Date(timeIntervalSince1970: 1136055660.0)
        // 1989
        datePickerView.date = Date(timeIntervalSince1970: 599598060.0)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(datePickerView)
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: datePickerView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: datePickerView.topAnchor)
        ])
    }
    
    private func setPickerView() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: 70),
        ])
    }
    
    
    private func setDoneButton() {
        
        doneBtn.backgroundColor = Constants.AppColorLiteral.nextButtonColor
        doneBtn.layer.cornerRadius = 10
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(doneBtn)
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: doneBtn.leadingAnchor, constant: -15),
            mainView.trailingAnchor.constraint(equalTo: doneBtn.trailingAnchor, constant: 15),
            mainView.bottomAnchor.constraint(equalTo: doneBtn.bottomAnchor, constant: 25),
            //datePickerView.bottomAnchor.constraint(equalTo: doneBtn.topAnchor),
            doneBtn.heightAnchor.constraint(equalToConstant: 47)
        ])
    }
    
    
    private func show() {
        
        UIView.animate(withDuration: 0.5) {
            self.bottomConstraint.constant = self.isShowing ? 0 : -1 * self.contentView.frame.width * 10
            self.greyView.alpha = self.isShowing ? 1 : 0
            self.contentView.layoutIfNeeded()
        }
    }
    
    @objc func greyViewTapped() {
        isShowing = false
    }
    
    func getValue(format: String = "MMM d, yyyy") -> String {
        
        if showDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: datePickerView.date)
        }
        
        let row = pickerView.selectedRow(inComponent: 0)
        return pickerValues[row]
    }
    
    func setPicker(values: [String]) {
        pickerValues = values
        pickerView.reloadAllComponents()
    }
    
    
}


extension ContentPickerView : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }
    
}
