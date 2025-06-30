//
//  UIRefreshControl.swift
//  EvaConnect
//
//  Created by Muhammad Salman on 4/12/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit


extension UIRefreshControl {
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}
