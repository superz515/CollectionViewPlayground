//
//  CollectionDataModel.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 2/28/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

/// A simple model providing data to UICollectionView.
class CollectionDataModel {
    private let defaultCount = 10

    private var count = 0

    private weak var delegate: CollectionDataModelDelegate?

    init(count iCount: Int? = nil, delegate iDelegate: CollectionDataModelDelegate?) {
        count = iCount ?? defaultCount
        delegate = iDelegate
    }
}

// MARK: - public methods
extension CollectionDataModel {
    // reset to default state
    func reset() {
        count = defaultCount
    }

    func cardCount() -> Int {
        return count
    }

    func color(at index: Int) -> UIColor {
        return UIColor.random
    }

    func updateCount(_ newCount: Int) {
        let oldCount = count
        count = newCount
        if newCount == oldCount + 1 {
            delegate?.insertCard()
        } else if newCount == oldCount - 1 {
            delegate?.removeCard()
        } else {
            delegate?.countChanged()
        }
    }
}

protocol CollectionDataModelDelegate: class {
    func countChanged()
    func insertCard()
    func removeCard()
}
