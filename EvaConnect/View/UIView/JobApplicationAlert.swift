//
//  JobApplicationAlert.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 2/14/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit

class JobApplicationAlert: UIView {
    
    enum AlertTyle: String {
        case job = "ic_job_application", application = "ic_application", jobUpdated = "ic_job_updated"
    }
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        image.isHidden = true
        return image
    }()
    
    private var okBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var contentView: UIView = UIApplication.shared.keyWindow!
    
    var okAction: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    init(type: AlertTyle) {
        super.init(frame: .zero)
        imageView.image = UIImage(named: type.rawValue)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JobApplicationAlert {
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self)
        addSubview(mainView)
        addSubview(imageView)
        addSubview(okBtn)
        
        NSLayoutConstraint.activate([
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: mainView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            leadingAnchor.constraint(equalTo: okBtn.leadingAnchor, constant: -40),
            trailingAnchor.constraint(equalTo: okBtn.trailingAnchor, constant: 40),
            imageView.bottomAnchor.constraint(equalTo: okBtn.bottomAnchor),
            okBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        okBtn.addTarget(self, action: #selector(okBtnTapped), for: .touchUpInside)
        isHidden = true
    }
    
    func showAlert() {
        isHidden = false
        mainView.alpha = 0
        imageView.alpha = 0
        okBtn.isHidden = false
        imageView.isHidden = false
        mainView.isHidden = false
        
        UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) {
            self.mainView.alpha = 1
            self.imageView.alpha = 1
            self.imageView.transform = .identity
        }.startAnimation()
    }
    
    @objc private func okBtnTapped() {
        okAction()
        removeFromSuperview()
    }
}
