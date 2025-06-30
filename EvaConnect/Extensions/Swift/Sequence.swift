//
//  Sequence.swift
//  EvaConnect
//
//  Created by usama on 19/08/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

extension Sequence {
      func commonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> [T.Iterator.Element]
        where T.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element {
            var common: [T.Iterator.Element] = []

            for lhsItem in lhs {
                for rhsItem in rhs {
                    if lhsItem == rhsItem {
                        common.append(lhsItem)
                    }
                }
            }
            return common
    }
}


