//
//  CarouselLayout.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 2/28/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class CarouselLayout: UICollectionViewFlowLayout {
    private struct LayoutState: Equatable {
        var collectionViewSize: CGSize
        var itemSize: CGSize
        var direction: UICollectionView.ScrollDirection
    }

    private var state = LayoutState(collectionViewSize: .zero, itemSize: .zero, direction: .horizontal)

    // size per unit in scroll direction
    var pageWidth: CGFloat {
        switch scrollDirection {
        case .horizontal:
            return itemSize.width + minimumLineSpacing
        case .vertical:
            return itemSize.height + minimumLineSpacing
        }
    }
    // index of current centered page
    var currentCenteredPage: Int? {
        guard let collectionView = collectionView else {
            return nil
        }
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width / 2,
                                           y: collectionView.contentOffset.y + collectionView.bounds.height / 2)
        return collectionView.indexPathForItem(at: currentCenteredPoint)?.row
    }

    // MARK: - override methods
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        let newState = LayoutState(collectionViewSize: collectionView.bounds.size,
                                       itemSize: itemSize,
                                       direction: scrollDirection)
        if state != newState {
            collectionView.decelerationRate = .fast
//            setup()
            state = newState
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
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
        switch scrollDirection {
        case .horizontal:
            finalOffset = targetAttributes.center.x - collectionView.bounds.width / 2
            delta = finalOffset - collectionView.contentOffset.x

            if (velocity.x < 0 && delta > 0) || (velocity.x > 0 && delta < 0) {
                finalOffset += velocity.x > 0 ? pageWidth : -pageWidth
            }
            return CGPoint(x: finalOffset, y: proposedContentOffset.y)
        case .vertical:
            finalOffset = targetAttributes.center.y - collectionView.bounds.height / 2
            delta = finalOffset - collectionView.contentOffset.y

            if (velocity.y < 0 && delta > 0) || (velocity.y > 0 && delta < 0) {
                finalOffset += velocity.y > 0 ? pageWidth : -pageWidth
            }
            return CGPoint(x: proposedContentOffset.x, y: finalOffset)
        }
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

    private func calculateProposedRect(collectionView: UICollectionView, proposedContentoffset: CGPoint) -> CGRect {
        let size = collectionView.bounds.size
        let origin: CGPoint
        switch scrollDirection {
        case .horizontal:
            origin = CGPoint(x: proposedContentoffset.x, y: collectionView.contentOffset.y)
        case .vertical:
            origin = CGPoint(x: collectionView.contentOffset.x, y: proposedContentoffset.y)
        }
        return CGRect(origin: origin, size: size)
    }

    private func targetLayoutAttributes(collectionView: UICollectionView,
                                        layoutAttributes: [UICollectionViewLayoutAttributes],
                                        proposedContentOffset: CGPoint) -> UICollectionViewLayoutAttributes? {
        var targetAttributes: UICollectionViewLayoutAttributes? = nil
        let proposedCenterOffset: CGFloat

        // figure out proposed center offset
        switch scrollDirection {
        case .horizontal:
            proposedCenterOffset = proposedContentOffset.x + collectionView.bounds.width / 2
        case .vertical:
            proposedCenterOffset = proposedContentOffset.y + collectionView.bounds.height / 2
        }

        // look for the closest item to proposed center
        for attributes in layoutAttributes {
            guard attributes.representedElementCategory == .cell else {
                continue
            }
            guard targetAttributes != nil else {
                targetAttributes = attributes
                continue
            }

            switch scrollDirection {
            case .horizontal where abs(attributes.center.x - proposedCenterOffset) < abs(targetAttributes!.center.x - proposedCenterOffset):
                targetAttributes = attributes
            case .vertical where abs(attributes.center.y - proposedCenterOffset) < abs(targetAttributes!.center.y - proposedCenterOffset):
                targetAttributes = attributes
            default:
                continue
            }
        }

        return targetAttributes
    }
}

// MARK: - public methods
extension CarouselLayout {
    // scroll to specific page
    func scrollToPage(at index: Int, animated: Bool) {
        guard let collectionView = collectionView else {
            return
        }

        let proposedContentOffset: CGPoint
        let shouldAnimate: Bool
        switch scrollDirection {
        case .horizontal:
            let pageOffset = CGFloat(index) * pageWidth - collectionView.contentInset.left
            proposedContentOffset = CGPoint(x: pageOffset, y: collectionView.contentOffset.y)
            shouldAnimate = abs(collectionView.contentOffset.x - pageOffset) > 1 ? animated : false
        case .vertical:
            let pageOffset = CGFloat(index) * pageWidth - collectionView.contentInset.top
            proposedContentOffset = CGPoint(x: collectionView.contentOffset.x, y: pageOffset)
            shouldAnimate = abs(collectionView.contentOffset.y - pageOffset) > 1 ? animated : false
        }
        collectionView.setContentOffset(proposedContentOffset, animated: shouldAnimate)
    }
}
