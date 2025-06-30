//
//  DynamicSizeTableView.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/27/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class DynamicSizeTableView: UITableView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize { invalidateIntrinsicContentSize() }
    }
    
    override public var intrinsicContentSize: CGSize {
        return contentSize
    }
    
}
