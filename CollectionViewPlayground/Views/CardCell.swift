//
//  CardCell.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 2/28/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    // MARK: - constants
    // reuse identifier
    static let identifier = "CardCell"

    private let headerHeight: CGFloat = 100

    // MARK: - views
    private lazy var headerView: HeaderView = {
        let header = HeaderView(frame: CGRect.zero)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    private lazy var roundedBackgroundView: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 15
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    var cellColor: UIColor = UIColor.white {
        didSet {
            roundedBackgroundView.backgroundColor = cellColor
        }
    }
    var character: Character? = Character.allCases.randomElement() {
        didSet {
            headerView.character = character
        }
    }

    private var headerHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(headerView)
        contentView.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubview(titleLabel)

        headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint?.isActive = true

        roundedBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        roundedBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        roundedBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        roundedBackgroundView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

        titleLabel.centerXAnchor.constraint(equalTo: roundedBackgroundView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: roundedBackgroundView.centerYAnchor).isActive = true
    }
}

// MARK: - for TitledCarouselLayout
extension CardCell {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let titledAttributes = layoutAttributes as? TitledLayoutAttributes else {
            headerView.alpha = 0
            headerHeightConstraint?.constant = 0
            animate(to: 1)
            return
        }

        headerView.alpha = 1
        headerHeightConstraint?.constant = headerHeight
        animate(to: titledAttributes.progress)
    }

    private func animate(to progress: CGFloat) {
        let offset = headerHeight - (progress * headerHeight)
        roundedBackgroundView.transform = CGAffineTransform(translationX: 0, y: -offset)
    }
}
