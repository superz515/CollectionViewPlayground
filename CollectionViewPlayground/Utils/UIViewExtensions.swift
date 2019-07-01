//
//  UIViewExtensions.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/4/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

// MARK: - ability to perform multiple animation with multiple UIViews
extension UIView {
    // perform successive animations on multiple UIViews
    // - views: UIViews to be animated
    // - animations: animations to be performed
    // - reversed: animation will start form original position and back if is reversed
    // - initial alpha: initial alpha of animated UIView
    // - final alpha: final alpha of animated UIView
    // - delay: time to wait before animations start
    // - animationInterval: interval between successive animations for UIViews
    // - duration: total duration of animations for each UIView
    // - options: AnimationOptions
    // - completion: block to be executed after animations end
    static func animate(views: [UIView],
                        animations: [Animation],
                        reversed: Bool = false,
                        initialAlpha: CGFloat = 0,
                        finalAlpha: CGFloat = 1,
                        delay: Double = 0,
                        animationInterval: TimeInterval = 0.05,
                        duration: TimeInterval = ViewAnimatorDefaults.duration,
                        options: UIView.AnimationOptions = [],
                        completion: (() -> Void)? = nil) {
        guard views.count > 0 else {
            completion?()
            return
        }

        // set initial alpha
        views.forEach({ $0.alpha = initialAlpha })
        // create a dispatch group to control the beginning and ending of animations
        let dispatchGroup = DispatchGroup()
        for _ in 0..<views.count {
            dispatchGroup.enter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            for (index, view) in views.enumerated() {
                view.animate(animations: animations,
                             reversed: reversed,
                             initialAlpha: initialAlpha,
                             finalAlpha: finalAlpha,
                             delay: Double(index) * animationInterval,
                             duration: duration,
                             options: options,
                             completion: {
                                dispatchGroup.leave()
                })
            }
        })

        // execute completion block when all animations end
        dispatchGroup.notify(queue: .main, execute: {
            completion?()
        })
    }

    // perform animation on UIView
    // - animations: animations to be performed
    // - reversed: animation will start from original position
    // - initial alpha: initial alpha of animated UIView
    // - final alpha: final alpha of animated UIView
    // - delay: time to wait before animations start
    // - duration: total duration of animations
    // - options: AnimationOptions
    // - completion: block to be executed after animations end
    func animate(animations: [Animation],
                 reversed: Bool = false,
                 initialAlpha: CGFloat = 0,
                 finalAlpha: CGFloat = 1,
                 delay: Double = 0,
                 duration: TimeInterval = ViewAnimatorDefaults.duration,
                 options: UIView.AnimationOptions = [],
                 completion: (() -> Void)? = nil) {
        let initialTransform = transform
        var finalTransform = transform
        animations.forEach({ finalTransform = finalTransform.concatenating($0.initialTransform)})
        if !reversed {
            transform = finalTransform
        }

        alpha = initialAlpha
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: { [weak self] in
                        self?.transform = reversed ? finalTransform : initialTransform
                        self?.alpha = finalAlpha
        }, completion: { _ in
            completion?()
        })
    }
}

