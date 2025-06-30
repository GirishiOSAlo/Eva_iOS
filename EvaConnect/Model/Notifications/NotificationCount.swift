//
//  NotificationCount.swift
//  EvaConnect
//
//  Created by usama on 26/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NotificationCountRoot: Codable {
    let error: Bool
    let message: String
    let data: [NotificationCount]
}


// MARK: - Datum
struct NotificationCount: Codable {
    let notification_count, connection_count: Int
}
