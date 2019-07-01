//
//  AnotherStackLayout.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 4/5/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class AnotherStackLayout: UICollectionViewFlowLayout {
    var firstItemTransform: CGFloat? = 0.05

    // MARK: - override methods
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        return attributes.map({ self.transformAttributes($0) })
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: - private methods
    private func transformAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else {
            return attributes
        }
        // minY is the most "top" position that one item could reach
        let minY = collectionView.bounds.minY + collectionView.contentInset.top

        var origin = attributes.frame.origin
        // originY is the top of the current item
        let originY = max(origin.y, minY)

        // apply transform
        let deltaY = (originY - origin.y) / attributes.frame.height
        print("\(deltaY)")
        if let itemTransform = firstItemTransform {
            let scale = 1 - deltaY * itemTransform
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        origin.y = originY
        attributes.frame = CGRect(origin: origin, size: attributes.frame.size)

        // later item covers former
        attributes.zIndex = attributes.indexPath.row
        return attributes
    }
}
