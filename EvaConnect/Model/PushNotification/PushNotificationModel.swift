//
//  PushNotificationModel.swift
//  EvaConnect
//
//  Created by usama on 28/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

struct PushNotificationRoot: Codable {
    let error: Bool
    let message: String
    let data: [EvaUser]
}


