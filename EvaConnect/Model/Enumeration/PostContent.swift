//
//  PostContent.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/5/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit

enum PostContent: Equatable {
    case text(String, CGFloat)
    case image(URL?, UIImage?)
    case video(URL, UIImage)
    case document(URL)
    
    var text: String! {
        switch self {
        case .text(let text, _):
            return text
        default:
            return ""
        }
    }
    
    var url: URL? {
        switch self {
        case .text(_, _):
            return nil
        case .image(let url, _):
            return url
        case .video(let url, _):
            return url
        case .document(let url):
            return url
        }
    }
    
    var isText: Bool! {
        if case .text(_, _) = self { return true }
        return false
    }
    
    var isImage: Bool! {
        if case .image(_, _) = self { return true }
        return false
    }
    
    var isVideo: Bool! {
        if case .video(_, _) = self { return true }
        return false
    }
    
    var isDocument: Bool! {
        if case .document(_) = self { return true }
        return false
    }
    
}
