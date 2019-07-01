//
//  OverlapLayout.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/20/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class OverlapLayout: UICollectionViewLayout {
    // MARK: - configurable properties
    var itemSize: CGSize = CGSize(width: 50, height: 50) {
        didSet {
            invalidateLayout()
        }
    }
    var overlapOffset: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    var sideItemAlpha: CGFloat = 0.6
    var sideItemScale: CGFloat = 0.7
    var sideItemShift: CGFloat = 0

    private var sectionInset: UIEdgeInsets = .zero

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }

        let itemCount = collectionView.numberOfItems(inSection: 0)
        let width = max(collectionView.bounds.width, itemSize.width + CGFloat(itemCount - 1) * overlapOffset)
        return CGSize(width: width + sectionInset.left + sectionInset.right, height: collectionView.bounds.height)
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        collectionView.decelerationRate = .fast
        setup()
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)

        var allAttributes = [UICollectionViewLayoutAttributes]()
        for index in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: index, section: 0)
            allAttributes.append(layoutAttributesForItem(at: indexPath)!)
        }
        let collectionViewCenter = collectionView.bounds.width / 2
        let sorted = allAttributes.sorted(by: { first, second in
            let firstCenter = abs(first.center.x - collectionView.contentOffset.x - collectionViewCenter)
            let secondCenter = abs(second.center.x - collectionView.contentOffset.x - collectionViewCenter)
            return firstCenter < secondCenter
        })
        for (i, attribute) in sorted.enumerated() {
            guard let index = allAttributes.firstIndex(of: attribute) else {
                continue
            }
            allAttributes[index].zIndex = itemCount - i
        }
        return allAttributes.map({ self.transformLayoutAttributes($0) })
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        attributes.size = itemSize
        let centerX = itemSize.width / 2 + CGFloat(indexPath.item) * overlapOffset
        let centerY = collectionView!.bounds.height / 2
        attributes.center = CGPoint(x:centerX + sectionInset.left, y: centerY)
        attributes.zIndex = indexPath.item

        return attributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        // calculate proposed rect
        let proposedRect = calculateProposedRect(collectionView: collectionView, proposedContentoffset: proposedContentOffset)
        guard let layoutAttributes = layoutAttributesForElements(in: proposedRect),
            let targetAttributes = targetLayoutAttributes(collectionView: collectionView,
                                                          layoutAttributes: layoutAttributes,
                                                          proposedContentOffset: proposedContentOffset) else {
                                                            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                                                                             withScrollingVelocity: velocity)
        }

        var finalOffset: CGFloat
        let delta: CGFloat

        finalOffset = targetAttributes.center.x - collectionView.bounds.width / 2
        delta = finalOffset - collectionView.contentOffset.x

        if (velocity.x < 0 && delta > 0) || (velocity.x > 0 && delta < 0) {
            finalOffset += velocity.x > 0 ? itemSize.width : -itemSize.width
        }
        return CGPoint(x: finalOffset, y: proposedContentOffset.y)
    }

    // MARK: - private methods
    private func setup() {
        guard let collectionView = collectionView else {
            return
        }

        let collectionSize = collectionView.bounds.size

        let xInset = (collectionSize.width - itemSize.width) / 2
        let yInset = (collectionSize.height - itemSize.height) / 2
        sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
    }

    private func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else {
            return attributes
        }

        // calculate ratio based on distance between item center and collection view center
        let maxDelta = itemSize.width / 2
        let collectionViewCenter: CGFloat
        let itemCenter: CGFloat

        collectionViewCenter = collectionView.bounds.width / 2
        itemCenter = attributes.center.x - collectionView.contentOffset.x

        let delta = min(maxDelta, abs(collectionViewCenter - itemCenter))
        let ratio = (maxDelta - delta) / maxDelta

        // calculate properties based on ratio
        let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
        let scale = ratio * (1 - sideItemScale) + sideItemScale

        attributes.alpha = alpha
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)

        return attributes
    }

    private func calculateProposedRect(collectionView: UICollectionView, proposedContentoffset: CGPoint) -> CGRect {
        let size = collectionView.bounds.size
        let origin = CGPoint(x: proposedContentoffset.x, y: collectionView.contentOffset.y)
        return CGRect(origin: origin, size: size)
    }

    private func targetLayoutAttributes(collectionView: UICollectionView,
                                        layoutAttributes: [UICollectionViewLayoutAttributes],
                                        proposedContentOffset: CGPoint) -> UICollectionViewLayoutAttributes? {
        var targetAttributes: UICollectionViewLayoutAttributes? = nil
        let proposedCenterOffset = proposedContentOffset.x + collectionView.bounds.width / 2

        // look for the closest item to proposed center
        for attributes in layoutAttributes {
            guard attributes.representedElementCategory == .cell else {
                continue
            }
            guard targetAttributes != nil else {
                targetAttributes = attributes
                continue
            }

            if abs(attributes.center.x - proposedCenterOffset) < abs(targetAttributes!.center.x - proposedCenterOffset) {
                targetAttributes = attributes
            }
        }

        return targetAttributes
    }
}
