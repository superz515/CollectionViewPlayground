//
//  LayoutsModel.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 2/28/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

enum CollectionViewLayoutStyle: CaseIterable {
    case defaultFlow
    case carousel
    case advancedCarousel
    case titledCarousel
    case circle
    case bouncy
    case animated
    case overlap
    case stack
    case anotherStack

    func description() -> String {
        switch self {
        case .defaultFlow:
            return "Default Flow"
        case .carousel:
            return "Carousel"
        case .advancedCarousel:
            return "Advanced Carousel"
        case .titledCarousel:
            return "Titled Carousel"
        case .circle:
            return "Circle"
        case .bouncy:
            return "Bouncy"
        case .animated:
            return "Animated"
        case .overlap:
            return "Overlap"
        case .stack:
            return "Stack"
        case .anotherStack:
            return "Another Stack"
        }
    }

    func detailedDescription() -> String {
        switch self {
        case .defaultFlow:
            return "default implementation of UICollectionViewFlowLayout"
        case .carousel:
            return "carousel layout always tries to center an item"
        case .advancedCarousel:
            return "advanced carousel could focus on centered item with additional appearance"
        case .titledCarousel:
            return "a different way to handle foused item"
        case .circle:
            return "circle around"
        case .bouncy:
            return "everything bounces"
        case .animated:
            return "show cells with animation"
        case .overlap:
            return "cells overlap with each other"
        case .stack:
            return "stacked with slight offset and scale"
        case .anotherStack:
            return "stacked to top"
        }
    }
}

/// This class holds all kinds of custom layouts.
class LayoutsModel {
    private(set) var currentStyle: CollectionViewLayoutStyle = .defaultFlow
    var currentLayout: UICollectionViewLayout {
        // look up layouts dictionary
        if let layout = layoutsDict[currentStyle] {
            return layout
        } else {
            // create and store if not found
            let layout = createLayout(with: currentStyle)
            layoutsDict[currentStyle] = layout
            return layout
        }
    }

    weak var delegate: LayoutsModelDelegate?

    private(set) var layoutsDict: [CollectionViewLayoutStyle: UICollectionViewLayout] = [:]

    private func createLayout(with style: CollectionViewLayoutStyle) -> UICollectionViewLayout {
        switch style {
        case .defaultFlow:
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            return layout
        case .carousel:
            let layout = CarouselLayout()
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            return layout
        case .advancedCarousel:
            let layout = AdvancedCarouselLayout()
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            return layout
        case .titledCarousel:
            let layout = TitledCarouselLayout()
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            return layout
        case .circle:
            let layout = CircleLayout()
            layout.radius = 200
            return layout
        case .bouncy:
            let layout = BouncyLayout()
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            return layout
        case .animated:
            let layout = AnimatedLayout()
            layout.minimumInteritemSpacing = 10
            layout.scrollDirection = .horizontal
            return layout
        case .overlap:
            let layout = OverlapLayout()
            return layout
        case .stack:
            let layout = StackLayout()
            return layout
        case .anotherStack:
            let layout = AnotherStackLayout()
            layout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
            return layout
        }
    }
}

// MARK: - public methods
extension LayoutsModel {
    func count() -> Int {
        return CollectionViewLayoutStyle.allCases.count
    }

    func style(at index: Int) -> CollectionViewLayoutStyle {
        return CollectionViewLayoutStyle.allCases[index]
    }

    func didSelect(_ index: Int) {
        currentStyle = CollectionViewLayoutStyle.allCases[index]
        delegate?.didChangeLayout(to: currentLayout)
    }
}

protocol LayoutsModelDelegate: class {
    func didChangeLayout(to layout: UICollectionViewLayout)
}

class LayoutDefaults {
    // generic
    static let defaultItemWidth: CGFloat = 200
    static let defaultItemHeight: CGFloat = 350
    static let defaultItemSpacing: CGFloat = 10

    // advanced carousel
    static let defaultAlpha: CGFloat = 0.6
    static let defaultScale: CGFloat = 0.7
    static let defaultShift: CGFloat = 0

    // circle layout
    static let defaultRadius: CGFloat = 200

    // bouncy layout
    static let defaultResistance: CGFloat = 1200
    static let defaultBouncyLevel = 1

    // animated layout
    static let defaultMoveDirection = 0
    static let defaultMoveDistance: CGFloat = 30
    static let defaultZoomScale: CGFloat = 1
    static let defaultRotateAngle: CGFloat = 0
}
