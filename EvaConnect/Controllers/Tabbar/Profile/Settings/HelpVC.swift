//
//  HelpVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/31/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import WebKit

enum HelpSection: String {
    case help = "Help"
    case termsOfServices = "Terms of Service"
    case cookies = "Cookies Policy"
    case privacy = "Privacy Policy"
}

class HelpVC: BaseVC {

    @IBOutlet weak var headerTitleLbl: HeadingLabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    var section: HelpSection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        goBack()
    }
    
    @IBAction func emailBtnTapped(_ sender: Any) {
        print("email btn tapped")
    }
    @IBAction func donBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HelpVC {
    
    func setLayout() {
        let isHelp = section == .help
        headerTitleLbl.text = section.rawValue
        switch section {
        case .termsOfServices:
            if let url = URL(string: "\(EndPoints.termsconditions)") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        case .cookies:
            if let url = URL(string: "\(EndPoints.cookiesPolicy)") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        case .privacy:
            if let url = URL(string: "\(EndPoints.privacyPolicy)") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        default:
            break
        }
        
        emailBtn.setTitle(isHelp ? Constants.Label.email : section.rawValue, for: .normal)
        emailBtn.isUserInteractionEnabled = isHelp
        titleLbl.isHidden = !isHelp
        doneBtn.layer.cornerRadius = 24
    }
    
}
