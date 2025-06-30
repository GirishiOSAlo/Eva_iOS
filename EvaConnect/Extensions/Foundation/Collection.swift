//
//  Collection.swift
//  EvaConnect
//
//  Created by usama on 13/08/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import Foundation

extension Collection where Element: Equatable {

    func intersection(with filter: [Element]) -> [Element] {
        return self.filter { element in filter.contains(element) }
    }
}
