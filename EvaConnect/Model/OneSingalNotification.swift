////
////  OneSingalNotification.swift
////  EvaConnect
////
////  Created by Muhammad Salman on 3/22/22.
////  Copyright © 2022 HyperNym. All rights reserved.
////
//
//import Foundation
//
//// MARK: - OneSingalNotification
//struct OneSingalNotification: Codable {
//    let appId: String
//    let contentAvailable: Bool
//    let filters: [OneSingalNotificationFilter]
//    let contents: OneSingalNotificationContents
//    let data: OneSingalNotificationData
//
//    enum CodingKeys: String, CodingKey {
//        case appId = "app_id"
//        case contentAvailable = "content_available"
//        case filters, contents, data
//    }
//    
//    init(email: String, title: String, message: String, notificationType: Int, objectId: Int, objectType: String, silent: Bool = true) {
//        appId = OneSignalUtility.shared.appId
//        contentAvailable = silent
//        filters = [
//            OneSingalNotificationFilter(field: "tag", key: "email", relation: "=", value: email)
//        ]
//        contents = OneSingalNotificationContents(en: message)
//        data = OneSingalNotificationData(title: title, message: message, notificationType: notificationType, objectID: objectId, objectType: objectType)
//    }
//}
//
//// MARK: - Contents
//struct OneSingalNotificationContents: Codable {
//    let en: String
//}
//
//// MARK: - OneSingalNotificationData
//struct OneSingalNotificationData: Codable {
//    let title, message: String
//    let notificationType, objectID: Int
//    let objectType: String
//
//    enum CodingKeys: String, CodingKey {
//        case title, message
//        case notificationType = "notification_type"
//        case objectID = "object_id"
//        case objectType = "object_type"
//    }
//}
//
//// MARK: - OneSingalNotificationFilter
//struct OneSingalNotificationFilter: Codable {
//    let field, key, relation, value: String
//}
//
//// MARK: - OneSingalNotificationResponse
//struct OneSingalNotificationResponse: Codable {
//    let id: String
//}
