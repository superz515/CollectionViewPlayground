//
//  TitledLayoutAttributes.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/2/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

// subclass of UICollectionViewLayoutAttributes must override -copy and -isEqual
class TitledLayoutAttributes: UICollectionViewLayoutAttributes {
    // progress towards the center (value between 0 and 1)
    var progress: CGFloat = 0

    // MARK: - override methods
    override func copy(with zone: NSZone? = nil) -> Any {
        let copied = super.copy(with: zone)
        (copied as? TitledLayoutAttributes)?.progress = progress
        return copied
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? TitledLayoutAttributes, attributes.progress == progress else {
            return false
        }
        return super.isEqual(object)
    }
}
