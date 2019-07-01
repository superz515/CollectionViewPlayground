//
//  FoundationExtension.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/5/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import Foundation

extension Float {
    var clean: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
