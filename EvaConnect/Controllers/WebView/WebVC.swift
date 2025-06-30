//
//  WebVC.swift
//  EvaConnect
//
//  Created by usama on 01/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    var webView: WKWebView!
    var url: URL!
    var backButton: UIButton!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(url: URL) {
        self.init()
        self.url = url
    }

    override func viewDidLoad() {

        super.viewDidLoad()
//        initWebView()
//    }
//
//    func initWebView() {
//
//        webView = WKWebView()
//        view.addSubview(webView)
//
//        webView.withConstraints { (webViewLayout) -> [NSLayoutConstraint] in
//
//            return [ webViewLayout.alignTop(),
//                     webViewLayout.alignLeft(),
//                     webViewLayout.alignRight(),
//                     webViewLayout.alignBottom()
//            ]
//        }
//
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
        
        // Create a container view to hold the back button and WKWebView
                let containerView = UIView()
                view.addSubview(containerView)
                Constants.setUpperCornerRadius(uiView: view, radius: 30)
        
                // Back button
                backButton = UIButton(type: .system)
                backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
                containerView.addSubview(backButton)
                Constants.setUpperCornerRadius(uiView: containerView, radius: 30)

                // WKWebView
                webView = WKWebView()
                containerView.addSubview(webView)
                

                // Set up constraints for the container view
                containerView.translatesAutoresizingMaskIntoConstraints = false
                containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

                // Set up constraints for the back button
                backButton.translatesAutoresizingMaskIntoConstraints = false
                backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
                backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0
                ).isActive = true

                // Set up constraints for the WKWebView
                webView.translatesAutoresizingMaskIntoConstraints = false
                webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 5).isActive = true
                webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

                // Load a URL into the WKWebView
//                let url = URL(string: "https://example.com") // Replace with your URL
                let request = URLRequest(url: url!)
                webView.load(request)
            }
    
    @objc func goBack() {
        self.dismiss(animated: true)
    }

}
