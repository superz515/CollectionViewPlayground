//
//  BouncyLayout.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/3/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

enum BounceStyle: Int {
    case subtle = 0
    case regular = 1
    case prominent = 2

    var damping: CGFloat {
        switch self {
        case .subtle:
            return 0.9
        case .regular:
            return 0.5
        case .prominent:
            return 0.1
        }
    }

    var frequency: CGFloat {
        switch self {
        case .subtle:
            return 2
        case .regular:
            return 1.5
        case .prominent:
            return 1
        }
    }
}

class BouncyLayout: UICollectionViewFlowLayout {
    // MARK: - public properties
    var style: BounceStyle = .regular {
        didSet {
            animator.removeAllBehaviors()
        }
    }
    // better be between 800 - 1800
    var resistanceDenominator: CGFloat = 1200

    // MARK: - constants
    private let visibleAreaInset: CGFloat = 500

    // animator
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView,
            let attributes = super.layoutAttributesForElements(in: collectionView.bounds.insetBy(dx: -visibleAreaInset,
                                                                                                 dy: -visibleAreaInset)) else {
                return
        }

        // NOTE: just remove all behaviors to fix some issue when switching between layouts
        animator.removeAllBehaviors()

        // remove old behaviors for those are no longer visible
        oldBehaviors(of: attributes).forEach({ animator.removeBehavior($0) })
        // add new behaviors for those become visible
        newBehaviors(of: attributes).forEach({ animator.addAttachmentBehavior($0, style.damping, style.frequency) })
    }

    // query animator for attributes
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }

    // query animator for attributes
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator.layoutAttributesForCell(at: indexPath) ?? super.layoutAttributesForItem(at: indexPath)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }

        animator.behaviors.forEach({
            guard let behavior = $0 as? UIAttachmentBehavior, let item = behavior.items.first else {
                return
            }
            update(behavior: behavior, with: item, in: collectionView, for: newBounds)
            animator.updateItem(usingCurrentState: item)
        })

        return collectionView.bounds.width != newBounds.width
    }

    // find old behaviors
    private func oldBehaviors(of attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let visibleIndexPaths = attributes.map({ $0.indexPath })
        return animator.behaviors.compactMap({
            guard let behavior = $0 as? UIAttachmentBehavior,
                let itemAttributes = behavior.items.first as? UICollectionViewLayoutAttributes else {
                    return nil
            }
            // do not return it if it is still visible
            return visibleIndexPaths.contains(itemAttributes.indexPath) ? nil : behavior
        })
    }

    // find new behaviors
    private func newBehaviors(of attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let allExistingIndexPaths = animator.behaviors.compactMap({
            (($0 as? UIAttachmentBehavior)?.items.first as? UICollectionViewLayoutAttributes)?.indexPath
        })
        return attributes.compactMap({
            allExistingIndexPaths.contains($0.indexPath) ? nil : UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center)
        })
    }

    // update behavior
    private func update(behavior: UIAttachmentBehavior, with item: UIDynamicItem, in view: UICollectionView, for bounds: CGRect) {
        // bounds difference
        let delta = CGVector(dx: bounds.origin.x - view.bounds.origin.x,
                             dy: bounds.origin.y - view.bounds.origin.y)
        // closest item to the touch point get smaller resistance and vice versa
        let resistance = CGVector(dx: abs(view.panGestureRecognizer.location(in: view).x - behavior.anchorPoint.x) / resistanceDenominator,
                                  dy: abs(view.panGestureRecognizer.location(in: view).y - behavior.anchorPoint.y) / resistanceDenominator)

        switch scrollDirection {
        case .horizontal:
            item.center.x += delta.dx < 0 ? max(delta.dx, delta.dx * resistance.dx) : min(delta.dx, delta.dx * resistance.dx)
        case .vertical:
            item.center.y += delta.dy < 0 ? max(delta.dy, delta.dy * resistance.dy) : min(delta.dy, delta.dy * resistance.dy)
        }
    }
}
