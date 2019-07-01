//
//  ViewAnimator.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/4/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

protocol Animation {
    // start state for animation
    var initialTransform: CGAffineTransform { get }
}

enum AnimationType: Animation {
    case from(direction: AnimationDirection, offset: CGFloat)
    case zoom(scale: CGFloat)
    case rotate(angle: CGFloat)

    // initial transform
    var initialTransform: CGAffineTransform {
        switch self {
        case .from(direction: let direction, let offset):
            if direction.isVertical {
                return CGAffineTransform(translationX: 0, y: offset * direction.sign)
            } else {
                return CGAffineTransform(translationX: offset * direction.sign, y: 0)
            }
        case .zoom(let scale):
            return CGAffineTransform(scaleX: scale, y: scale)
        case .rotate(let angle):
            return CGAffineTransform(rotationAngle: angle)
        }
    }
}

enum AnimationDirection: Int {
    case top
    case left
    case right
    case bottom

    // check if animation happens on X or Y axis
    var isVertical: Bool {
        switch self {
        case .top, .bottom:
            return true
        case .left, .right:
            return false
        }
    }

    // as a factor when calculating animation
    var sign: CGFloat {
        switch self {
        case .top, .left:
            return -1
        case .right, .bottom:
            return 1
        }
    }
}

// default parameters for view animations
class ViewAnimatorDefaults {
    // duration of animation
    static var duration: Double = 0.3

    // interval between successive animations of UIViews
    static var interval: Double = 0.075

    // default offset for .from animation
    static var offset: CGFloat = 30

    // maximum zoom scale for .zoom animation
    static var maxZoomScale: Double = 2

    // maximum rotation angle for .rotate animation
    static var maxRotationAngle: CGFloat = CGFloat.pi / 4
}
