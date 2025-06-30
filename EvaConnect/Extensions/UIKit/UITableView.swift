//
//  UITableView.swift
//  EvaConnect
//
//  Created by usama on 20/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

public protocol Dequeueable {
    static func id() -> String
    static func hasNib() -> Bool
}

public extension UITableView {
    
    func getCell<T: Dequeueable>(forType: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: T.id()) as? T
    }
    
    func registerCell(withType cType: Dequeueable.Type) {
        registerCells(withTypes: [cType])
    }
    
    func registerCells(withTypes cType: [Dequeueable.Type]) {
        for ty in cType {
            if ty.hasNib() {
                register(UINib(nibName: ty.id(), bundle: Bundle.main), forCellReuseIdentifier: ty.id())
            } else {
                if let t = ty as? AnyClass {
                    register(t, forCellReuseIdentifier: ty.id())
                }
            }
        }
    }
    
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 {
            return
        }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
    
     func reloadDataAndKeepOffset() {
        // stop scrolling
        setContentOffset(contentOffset, animated: false)
        
        // calculate the offset and reloadData
        let beforeContentSize = contentSize
        //        layoutIfNeeded()

        reloadData()
        layoutIfNeeded()

        let afterContentSize = contentSize
        
        // reset the contentOffset after data is updated
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height))
        setContentOffset(newOffset, animated: false)
    }
    
    func dequeueReusableCell<T: ReusableCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.ReuseId, for: indexPath ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.ReuseId)")
        }
        return cell
    }

}

