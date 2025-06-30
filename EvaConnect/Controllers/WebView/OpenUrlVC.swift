//
//  OpenUrlVC.swift
//  EvaConnect
//
//  Created by Metis on 14/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit

class OpenUrlVC: BaseVC,WKUIDelegate{
    
    @IBOutlet weak var web: WKWebView!
    @IBOutlet weak var webKitView: WKWebView!
    
    var contentString: String?
    var urlSring: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let link = URL(string:contentString ?? "www.google.com")!
        let request = URLRequest(url: link)
        web.load(request)
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
