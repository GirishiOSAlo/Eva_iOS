//
//  UIViewController.swift
//  EvaConnect
//
//  Created by usama on 20/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import IHProgressHUD
import SVProgressHUD

extension UIViewController {

    func showActivity(isUserInteractionEnabled: Bool = true) {
        SVProgressHUD.show()
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    func hideActivity(isUserInteractionEnabled: Bool = true) {
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    func presentAlert(_ title: String?, _ msg: String? = nil, _ error: Error? = nil, completion: (() -> Void)? = nil) {
        let tlt = title ?? "OK"
        let msg = error?.localizedDescription ?? msg ?? ""
        let alert = UIAlertController(title: tlt, message: msg)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let completion = completion { completion() }
        }))
        present(alert, animated: true)
    }
    
    func presentAlertWithAction(title: String, message: String, positiveTitle: String = "Okay", negativeTitle: String = "Cancel",
                                completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction.init(title: negativeTitle, style: .cancel))
        alertController.addAction(UIAlertAction.init(title: positiveTitle, style: .default, handler: { (_) in
            completion()
        }))
        self.present(alertController, animated: true, completion: nil)
      }

    func dashboardViewController() {
        let tabVC = StoryboardRouter.tabbar()
        tabVC.setupTabBar()
        tabVC.selectedIndex = 0
        (UIApplication.shared.delegate as! AppDelegate)
            .window?
            .switchRootViewController(tabVC)
    }
    
    func popupView(uiView: UIView){
        uiView.layer.masksToBounds = true;
        uiView.layer.cornerRadius = 30
        uiView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 150, y: self.view.frame.size.height - 100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        })
    }
    
    func showToastWithLogo(message: String, duration: TimeInterval = 2.0) {
        // Create a view to hold the logo and label
        let toastView = UIView(frame: CGRect(x: self.view.frame.size.width / 2 - 150, y: self.view.frame.size.height - 100, width: 300, height: 50))
        toastView.backgroundColor = UIColor.white
        toastView.alpha = 0.0
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true

        // Create an image view for your app logo
        let logoImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        logoImageView.image = UIImage(named: "ic_navLogo") // Replace "your_app_logo" with the actual image name
        logoImageView.contentMode = .scaleAspectFit

        // Create a label for the toast message
        let toastLabel = UILabel(frame: CGRect(x: logoImageView.frame.maxX + 10, y: 0, width: toastView.frame.width - (logoImageView.frame.maxX + 20), height: toastView.frame.height))
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message

        // Add the image view and label to the toast view
        toastView.addSubview(logoImageView)
        toastView.addSubview(toastLabel)

        // Add the toast view to the view hierarchy
        self.view.addSubview(toastView)

        // Animate the toast view
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            toastView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastView.alpha = 0.0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        })
    }
    
    
    func showCustomAlert(title: String, doneTitle: String, on view: UIView, action: @escaping () -> Void) {
        let alert = AlertView(title: title, doneBtnTitle: doneTitle, actionHandler: action)
        alert.frame = self.view.bounds
        alert.backgroundColor = UIColor(hex: "#808080", alpha: 0.36) // Optional overlay
        self.view.addSubview(alert)
    }
}
