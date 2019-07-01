//
//  UIDynamicAnimatorExtension.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/3/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

extension UIDynamicAnimator {
    func addAttachmentBehavior(_ behavior: UIAttachmentBehavior, _ damping: CGFloat, _ frequency: CGFloat) {
        behavior.damping = damping
        behavior.frequency = frequency
        addBehavior(behavior)
    }
}
