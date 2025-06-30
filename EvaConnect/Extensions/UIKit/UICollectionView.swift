//
//  UICollectionView.swift
//  EvaConnect
//
//  Created by usama on 17/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    public func registerNib(cellNib cell: ReusableCell.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName:cell.NibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: cell.ReuseId)
    }
    
    public func registerClass(cellClass cell: ReusableCell.Type) {
        register(cell, forCellWithReuseIdentifier: cell.ReuseId)
    }
    
    func dequeueReusableCell<T: ReusableCell>(forIndexPath indexPath: IndexPath) -> T{
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.ReuseId, for: indexPath ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.ReuseId)")
        }
        return cell
    }
}
