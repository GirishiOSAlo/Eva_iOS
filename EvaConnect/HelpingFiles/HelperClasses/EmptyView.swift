//
//  EmptyView.swift
//  EvaConnect
//
//  Created by Pranay Barua on 01/03/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import Foundation
import UIKit

class NoDataView: UIView {
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No data found"
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(messageLabel)

        // Add constraints as needed
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
