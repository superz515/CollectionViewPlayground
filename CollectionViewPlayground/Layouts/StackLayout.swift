//
//  StackLayout.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/9/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class StackLayout: UICollectionViewLayout {
    // MARK: - configurable properties
    var itemSize: CGSize = CGSize(width: 200, height: 350)
    var spacing: CGFloat = 10
    var maxVisibleItems = 4

    override open var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        let itemCount = collectionView.numberOfItems(inSection: 0)
        return CGSize(width: collectionView.bounds.width * CGFloat(itemCount),
                      height: collectionView.bounds.height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return super.layoutAttributesForElements(in: rect)
        }

        // calculate scope of visible items
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let minVisibleIndex = max(Int(collectionView.contentOffset.x) / Int(collectionView.bounds.width), 0)
        let maxVisibleIndex = min(minVisibleIndex + maxVisibleItems, itemCount)

        let contentCenterX = collectionView.contentOffset.x + (collectionView.bounds.width / 2)
        let deltaOffset = CGFloat(Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width))
        let percentageDeltaOffset = deltaOffset / collectionView.bounds.width

        let visibleIndexes = stride(from: minVisibleIndex, to: maxVisibleIndex, by: 1)
        let attributes: [UICollectionViewLayoutAttributes] = visibleIndexes.map({ index in
            return layoutAttributesForItem(at: IndexPath(row: index, section: 0),
                                           minVisibleIndex: minVisibleIndex,
                                           contentCenterX: contentCenterX,
                                           deltaOffset: deltaOffset,
                                           percentageDeltaOffset: percentageDeltaOffset)
        })
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return super.layoutAttributesForItem(at: indexPath)
        }

        let minVisibleIndex = Int(collectionView.contentOffset.x) / Int(collectionView.bounds.width)
        let contentCenterX = collectionView.contentOffset.x + (collectionView.bounds.width / 2)
        let deltaOffset = CGFloat(Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width))
        let percentageDeltaOffset = deltaOffset / collectionView.bounds.width

        return layoutAttributesForItem(at: indexPath,
                                       minVisibleIndex: minVisibleIndex,
                                       contentCenterX: contentCenterX,
                                       deltaOffset: deltaOffset,
                                       percentageDeltaOffset: percentageDeltaOffset)
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: - private methods
    private func layoutAttributesForItem(at indexPath: IndexPath, minVisibleIndex: Int, contentCenterX: CGFloat, deltaOffset: CGFloat, percentageDeltaOffset: CGFloat) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else {
            return UICollectionViewLayoutAttributes(forCellWith: indexPath)
        }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let visibleIndex = indexPath.row - minVisibleIndex
        attributes.size = itemSize

        let minY = collectionView.bounds.midY
        attributes.center = CGPoint(x: contentCenterX + spacing * CGFloat(visibleIndex),
                                    y: minY + spacing * CGFloat(visibleIndex))
        attributes.zIndex = maxVisibleItems - visibleIndex
        attributes.transform = transform(at: visibleIndex, percentageOffset: percentageDeltaOffset)

        switch visibleIndex {
        case 0:
            attributes.center.x -= deltaOffset
        case 1..<maxVisibleItems:
            attributes.center.x -= spacing * percentageDeltaOffset
            attributes.center.y -= spacing * percentageDeltaOffset

            if visibleIndex == maxVisibleItems - 1 {
                attributes.alpha = percentageDeltaOffset
            }
        default:
            attributes.alpha = 0
        }

        return attributes
    }

    private func transform(at visibleIndex: Int, percentageOffset: CGFloat) -> CGAffineTransform {
        var rawScale: CGFloat = visibleIndex < maxVisibleItems ? scale(at: visibleIndex) : 1

        if visibleIndex != 0 {
            let previousScale = scale(at: visibleIndex - 1)
            let delta = (previousScale - rawScale) * percentageOffset
            rawScale += delta
        }

        return CGAffineTransform(scaleX: rawScale, y: rawScale)
    }

    private func scale(at index: Int) -> CGFloat {
        let factor = CGFloat(index) - CGFloat(maxVisibleItems) / 2
        return CGFloat(pow(0.95, factor))
    }
}
