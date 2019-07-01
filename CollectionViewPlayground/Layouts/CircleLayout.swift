//
//  CircleLayout.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/3/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class CircleLayout: UICollectionViewLayout {
    // MARK: - configurable properties
    var itemSize: CGSize = CGSize(width: 200, height: 350)
    var radius: CGFloat = 200

    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        layoutAttributes.removeAll()
        let count = collectionView.numberOfItems(inSection: 0)
        for i in 0..<count {
            let indexPath = IndexPath(row: i, section: 0)
            guard let attribtues = layoutAttributesForItem(at: indexPath) else {
                continue
            }
            layoutAttributes.append(attribtues)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return super.layoutAttributesForItem(at: indexPath)
        }

        let count = collectionView.numberOfItems(inSection: 0)
        // circle center
        let centerX = collectionView.bounds.width / 2
        let centerY = collectionView.bounds.height / 2

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        if count == 1 {
            attributes.center = CGPoint(x: centerX, y: centerY)
        } else {
            let angle = 2 * CGFloat.pi * CGFloat(indexPath.row) / CGFloat(count)
            let itemCenterX = centerX + radius * sin(angle)
            let itemCenterY = centerY + radius * cos(angle)
            attributes.center = CGPoint(x: itemCenterX, y: itemCenterY)
            attributes.zIndex = indexPath.row * 10
        }

        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
}
