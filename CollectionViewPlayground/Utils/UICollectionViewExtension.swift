//
//  UICollectionViewExtension.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/7/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

extension UICollectionView {
    /// VisibleCells in the order they are displayed on screen.
    var orderedVisibleCells: [UICollectionViewCell] {
        return indexPathsForVisibleItems.sorted().compactMap { cellForItem(at: $0) }
    }

    /// Gets the currently visibleCells of a section.
    ///
    /// - Parameter section: The section to filter the cells.
    /// - Returns: Array of visible UICollectionViewCells in the argument section.
    func visibleCells(in section: Int) -> [UICollectionViewCell] {
        return visibleCells.filter { indexPath(for: $0)?.section == section }
    }
}
