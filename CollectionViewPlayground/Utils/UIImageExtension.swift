//
//  UIImageExtension.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/2/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

extension UIImage {
    // randomly pick up an image from assets
    class func randomAvatar() -> UIImage? {
        let index = Int.random(in: 0...5)
        switch index {
        case 0:
            return UIImage(named: "wall-e")
        case 1:
            return UIImage(named: "nemo")
        case 2:
            return UIImage(named: "ratatouille")
        case 3:
            return UIImage(named: "buzz")
        case 4:
            return UIImage(named: "monsters")
        case 5:
            return UIImage(named: "brave")
        default:
            return UIImage(named: "wall-e")
        }
    }
}
