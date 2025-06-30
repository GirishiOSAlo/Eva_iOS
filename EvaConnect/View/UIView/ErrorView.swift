//
//  ErrorView.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 4/26/20.
//  Copyright © 2020 Muhammad Salman Zafar. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    let imageView : UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "outline_error_outline_black_36pt"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .white
        return img
    }()
    
    let titleLbl : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.textColor = .white
        lbl.text = "Error"
        return lbl
    }()
    
    let messageLbl : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Avenir-Medium", size: 16)
        lbl.textColor = .white
        lbl.text = "Services are not available in 'Islamabad'"
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var topConst: NSLayoutConstraint!
    private var contentView: UIView? = nil
    private var dismissTimer: Timer? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set()
    }
    
    init(contentView: UIView) {
        super.init(frame: .zero)
        
        self.contentView = contentView
        set()
        addConstraint(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func set() {
        backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.1137254902, blue: 0.1490196078, alpha: 1)
        setLayout()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    private func setLayout() {
        
        addSubview(imageView)
        addSubview(titleLbl)
        addSubview(messageLbl)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -16),
//            bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            imageView.topAnchor.constraint(equalTo: titleLbl.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            
            topAnchor.constraint(equalTo: titleLbl.topAnchor, constant: UIDevice.current.hasNotch ? -45 : -10),
//            imageView.topAnchor.constraint(equalTo: titleLbl.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            
            messageLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            titleLbl.bottomAnchor.constraint(equalTo: messageLbl.topAnchor),
            bottomAnchor.constraint(equalTo: messageLbl.bottomAnchor, constant: 5)
        ])
        
    }
    
    func addConstraint(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        topConst = view.topAnchor.constraint(equalTo: topAnchor, constant: 300)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            topConst,
            heightAnchor.constraint(greaterThanOrEqualToConstant: UIDevice.current.hasNotch ? 95 : 60),
//            heightAnchor.constraint(equalToConstant: 95)
        ])
    }
    
    func show(title: String = "Error", message: String, success: Bool = false) {
        titleLbl.text = title
        messageLbl.text = message
        
        if success {
            titleLbl.text = title == "Error" ? "Success" : title
            backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            imageView.image = UIImage(named: "check_cricle_36pt")
        }
        
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in self.showOrDismiss(false) }
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { (_) in self.showOrDismiss(true) }
    }
    
    private func showOrDismiss(_ show: Bool) {
        
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1.0) {
            self.topConst.constant = show ? 0 : 300
            self.contentView?.layoutIfNeeded() ?? self.layoutIfNeeded()
        }
        
        animator.addCompletion { (_) in if !show { self.removeFromSuperview() } }
        animator.startAnimation()
    }
    
    @objc func viewTapped() {
        dismissTimer?.invalidate()
        showOrDismiss(false)
    }
    
}
