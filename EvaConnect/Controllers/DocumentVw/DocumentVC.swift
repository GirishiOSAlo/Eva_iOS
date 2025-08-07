//
//  DocumentVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 07/08/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import WebKit

class DocumentVC: UIViewController, XIBed {
    
    @IBOutlet weak var baseView: UIView!
    var webView: WKWebView!
    var documentURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        print("Document URL : \(String(describing: documentURL))")
        webView = WKWebView(frame: self.baseView.bounds)
        self.baseView.addSubview(webView)
        if let url = URL(string: "http://18.168.230.15:2200/storage/assets/post/documents/5HDzJ1MHce.pdf") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
        
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
