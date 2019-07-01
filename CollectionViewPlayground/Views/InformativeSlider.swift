//
//  InformativeSlider.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 3/5/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

/// UISlider with UILabels showing its min and max values and tooltip showing its current value during changing
class InformativeSlider: UIView {
    // MARK: - public properties
    private(set) var value: CGFloat = 0

    // MARK: - constants
    private let spacing: CGFloat = 10

    // MARK: - views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    // stack view as the container
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [minLabel, slider, maxLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = spacing
        return stack
    }()
    private lazy var slider: UISlider = {
        let aSlider = UISlider()
        aSlider.translatesAutoresizingMaskIntoConstraints = false
        aSlider.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        aSlider.isContinuous = false
        return aSlider
    }()
    private lazy var minLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        return label
    }()
    private lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    // TODO
//    private lazy var tooltip
    
    // MARK: - private properties
    private var title: String = ""
    private var interval: Float = 0.1 {
        didSet {
            if interval < 0.1 {
                interval = 0.1
            }
        }
    }
    private weak var delegate: InformativeSliderDelegate?

    // MARK: - initializers
    init(delegate iDelegate: InformativeSliderDelegate?,
         title iTitle: String,
         value iValue: CGFloat,
         min: CGFloat,
         max: CGFloat,
         interval iInterval: CGFloat) {
        super.init(frame: CGRect.zero)

        delegate = iDelegate
        title = iTitle
        value = iValue
        titleLabel.text = title + " = \(Float(value).clean)"
        interval = Float(iInterval)
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.value = Float(value)
        minLabel.text = Float(min).clean
        maxLabel.text = Float(max).clean
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private methods
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(stackView)

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    @objc private func valueChanged(_ sender: UISlider) {
        let floatValue = round(sender.value / interval) * interval
        value = CGFloat(floatValue)
        titleLabel.text = title + " = \(floatValue.clean)"
        delegate?.slider(self)
    }
}

protocol InformativeSliderDelegate: class {
    func slider(_ slider: InformativeSlider)
}
