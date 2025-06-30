//
//  TableViewBase.swift
//  EvaConnect
//
//  Created by usama on 01/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class TableViewBase: BaseVC {

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.backgroundColor = AppearanceProxyManager.shared.th.lightGreyColor
        tableView.tableFooterView =  UIView()
    }
}
