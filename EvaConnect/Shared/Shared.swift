//
//  Shared.swift
//  EvaConnect
//
//  Created by usama on 10/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

enum SharedHeaders {
    static var headers =  [
        "Authorization": "Bearer \(LoggedUserDetails.shared.token ?? "")",
        "Os": "iOS" ]
}

protocol SelectionCellActionable: AnyObject {
    func selectedButton(sender: UIButton, completion: @escaping () -> Void)
}
