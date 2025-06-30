//
//  Array.swift
//  EvaConnect
//
//  Created by usama on 16/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

extension Array where Element: Operation {
    /// Execute block after all operations from the array.
    func onFinish(block: @escaping () -> Void) {
        let doneOperation = BlockOperation(block: block)
        self.forEach { [unowned doneOperation] in doneOperation.addDependency($0) }
        OperationQueue().addOperation(doneOperation)
    }
    
}



extension Array where Element : Equatable {
    public mutating func mergeElements<C : Collection>(newElements: C) where C.Iterator.Element == Element{
        let filteredList = newElements.filter({!self.contains($0)})
        self.append(contentsOf: filteredList)
    }
}

extension Array where Element: UITextView {

    func updateLayerWidth(_ toWidth: CGFloat) {

        self.forEach {
            $0.layer.sublayers?.forEach { layer in
                    var frame = layer.frame
                    frame.size.width = toWidth
                    layer.frame = frame
            }
        }
    }
}
