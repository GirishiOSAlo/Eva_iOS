//
//  PostDocumentCell.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/4/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit
import WebKit

class PostDocumentCell: UITableViewCell {

    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var documentNameLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    weak var delegate: PostTableViewCellDelegate? = nil

    var mode: PostLoadingMode! {
        didSet {
            removeBtn.isHidden = mode == .edit
        }
    }
    
    var content: (index: Int, url: URL)! {
        didSet  {
            webView.load(URLRequest(url: content.url))
            documentNameLbl.text = content.url.lastPathComponent
        }
    }
    
    @IBAction func removeBtnTapped(_ sender: Any) { delegate?.didRemoveCell(at: content.index, hasImage: false) }
}

extension PostDocumentCell: Dequeueable {
    
    static func id() -> String { String(describing: self) }
    static func hasNib() -> Bool { true }
    
}
