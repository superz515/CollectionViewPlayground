//
//  HeaderView.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/2/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

enum Character: CaseIterable {
    case walle
    case nemo
    case ratatouille
    case buzz
    case monsters
    case brave

    func name() -> String {
        switch self {
        case .walle:
            return "Wall-E"
        case .nemo:
            return "Nemo"
        case .ratatouille:
            return "Remy"
        case .buzz:
            return "Buzz Lightyear"
        case .monsters:
            return "Mike & Sullivan"
        case .brave:
            return "Merida"
        }
    }

    func avatar() -> UIImage? {
        switch self {
        case .walle:
            return UIImage(named: "wall-e")
        case .nemo:
            return UIImage(named: "nemo")
        case .ratatouille:
            return UIImage(named: "ratatouille")
        case .buzz:
            return UIImage(named: "buzz")
        case .monsters:
            return UIImage(named: "monsters")
        case .brave:
            return UIImage(named: "brave")
        }
    }
}

class HeaderView: UIView {
    // MARK: - constants
    private let viewPadding: CGFloat = 10
    private let imageVerticalPadding: CGFloat = 20

    var character: Character? {
        didSet {
            imageView.image = character?.avatar()
            titleLabel.text = character?.name()
        }
    }

    // MARK: - views
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // rounded corner for image view
        imageView.layer.cornerRadius = max(imageView.bounds.width, imageView.bounds.height) / 2
    }

    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)

        // auto layout
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: viewPadding).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: imageVerticalPadding).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -imageVerticalPadding).isActive = true
        imageView.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -viewPadding).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -viewPadding).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
