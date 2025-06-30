//
//  DatePicker.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 16/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation
import UIKit

class DatePickerSheetViewController: UIViewController {

    var onDateSelected: ((Date) -> Void)?
    var pickerMode: UIDatePicker.Mode = .date
    var maximumDate: Date?
    var minimumDate: Date?

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        //picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        return picker
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#4D76CD")
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        button.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        button.layer.cornerRadius = 12.0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(datePicker)
        view.addSubview(doneButton)
        
        datePicker.datePickerMode = pickerMode
        if let maxDate = maximumDate {
            datePicker.maximumDate = maxDate
        }
        if let minDate = minimumDate {
            datePicker.minimumDate = minDate
        }

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 80.0), // Set width
            doneButton.heightAnchor.constraint(equalToConstant: 44), // Set height
            doneButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
    }

    @objc private func didTapDone() {
        onDateSelected?(datePicker.date)
        dismiss(animated: true)
    }
}


