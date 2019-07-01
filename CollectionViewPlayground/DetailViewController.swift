//
//  DetailViewController.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 2/28/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - constants
    private let aroundPadding: CGFloat = 20
    private let stepperLabelPadding: CGFloat = 10
    private let stepperCollectionPadding: CGFloat = 20
    private let internalPadding: CGFloat = 20

    // MARK: - layouts model
    var layoutsModel: LayoutsModel?

    // MARK: - views
    private lazy var cardCountStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = Double.greatestFiniteMagnitude
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        return stepper
    }()
    private lazy var cardCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        // configure layout
        guard let layout = layoutsModel?.currentLayout else {
            fatalError()
        }

        // configure layout
        configureLayout(layout, width: widthControl.value, height: heightControl.value, spacing: spacingControl.value)

        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        collection.decelerationRate = .fast
        collection.contentInsetAdjustmentBehavior = .never
        collection.backgroundColor = .white

        return collection
    }()
    // generic option controls
    private lazy var widthControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Item Width", value: LayoutDefaults.defaultItemWidth, min: 50, max: 350, interval: 10)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    private lazy var heightControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Item Height", value: LayoutDefaults.defaultItemHeight, min: 50, max: 350, interval: 10)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    private lazy var spacingControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Item Spacing", value: LayoutDefaults.defaultItemSpacing, min: -100, max: 100, interval: 10)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    // option controls for advanced carousel
    private lazy var alphaControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Alpha", value: LayoutDefaults.defaultAlpha, min: 0.1, max: 1, interval: 0.1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()
    private lazy var scaleControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Scale", value: LayoutDefaults.defaultScale, min: 0.1, max: 1.1, interval: 0.1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()
    private lazy var shiftControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Y Shift", value: LayoutDefaults.defaultShift, min: 0, max: 50, interval: 5)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()
    // option control for circle layout
    private lazy var radiusControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Radius", value: LayoutDefaults.defaultRadius, min: 100, max: 220, interval: 20)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()
    // option controls for bouncy layout
    private lazy var resistanceControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Resistance", value: LayoutDefaults.defaultResistance, min: 800, max: 2400, interval: 100)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()
    private lazy var bouncyLevelControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Subtle", "Regular", "Prominent"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.addTarget(self, action: #selector(bouncyLevelChanged(_:)), for: .valueChanged)
        segmented.selectedSegmentIndex = LayoutDefaults.defaultBouncyLevel
        segmented.isHidden = true
        return segmented
    }()
    // option control for animated layout
    private lazy var moveDirectionControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Top", "Left", "Right", "Bottom"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.apportionsSegmentWidthsByContent = true
        segmented.addTarget(self, action: #selector(directionChanged(_:)), for: .valueChanged)
        segmented.selectedSegmentIndex = LayoutDefaults.defaultMoveDirection
        segmented.isHidden = true
        return segmented
    }()
    private lazy var moveDistanceControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Distance", value: LayoutDefaults.defaultMoveDistance, min: 0, max: 50, interval: 10)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()
    private lazy var zoomControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Zoom Scale", value: LayoutDefaults.defaultZoomScale, min: 0.1, max: 2, interval: 0.1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()
    private lazy var rotateControl: InformativeSlider = {
        let slider = InformativeSlider(delegate: self, title: "Rotate Angle", value: LayoutDefaults.defaultRotateAngle,
                                       min: 0, max: 180, interval: 10)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isHidden = true
        return slider
    }()

    // MARK: - model
    private lazy var collectionData: CollectionDataModel = CollectionDataModel(delegate: self)

    // MARK: - override methods and private methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // configure data
        configureData()

        // configure views
        setupViews()
        setupContraints()

        // title
        title = layoutsModel?.currentStyle.detailedDescription()
    }

    private func configureData() {
        collectionData.reset()
        cardCountStepper.value = Double(collectionData.cardCount())
        cardCountLabel.text = "\(collectionData.cardCount())"
    }

    private func setupViews() {
        view.addSubview(cardCountStepper)
        view.addSubview(cardCountLabel)
        view.addSubview(collectionView)

        // generic controls
        view.addSubview(widthControl)
        view.addSubview(heightControl)
        view.addSubview(spacingControl)

        // controls for advanced carousel
        view.addSubview(alphaControl)
        view.addSubview(scaleControl)
        view.addSubview(shiftControl)

        // control for circle layout
        view.addSubview(radiusControl)

        // control for bouncy layout
        view.addSubview(resistanceControl)
        view.addSubview(bouncyLevelControl)

        // controls for animated layout
        view.addSubview(moveDirectionControl)
        view.addSubview(moveDistanceControl)
        view.addSubview(zoomControl)
        view.addSubview(rotateControl)
    }

    private func setupContraints() {
        cardCountStepper.leftAnchor.constraint(equalTo: view.leftAnchor, constant: aroundPadding).isActive = true
        cardCountStepper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: aroundPadding).isActive = true

        cardCountLabel.leftAnchor.constraint(equalTo: cardCountStepper.rightAnchor, constant: stepperLabelPadding).isActive = true
        cardCountLabel.centerYAnchor.constraint(equalTo: cardCountStepper.centerYAnchor).isActive = true
        cardCountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        cardCountLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        // generic controls - same width
        widthControl.leftAnchor.constraint(equalTo: cardCountLabel.rightAnchor, constant: internalPadding).isActive = true
        widthControl.centerYAnchor.constraint(equalTo: cardCountStepper.centerYAnchor).isActive = true
        heightControl.leftAnchor.constraint(equalTo: widthControl.rightAnchor, constant: internalPadding).isActive = true
        heightControl.centerYAnchor.constraint(equalTo: cardCountStepper.centerYAnchor).isActive = true
        heightControl.widthAnchor.constraint(equalTo: widthControl.widthAnchor).isActive = true
        spacingControl.leftAnchor.constraint(equalTo: heightControl.rightAnchor, constant: internalPadding).isActive = true
        spacingControl.centerYAnchor.constraint(equalTo: cardCountStepper.centerYAnchor).isActive = true
        spacingControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -aroundPadding).isActive = true
        spacingControl.widthAnchor.constraint(equalTo: heightControl.widthAnchor).isActive = true

        // controls for advanced carousel - align with generic controls
        alphaControl.leftAnchor.constraint(equalTo: widthControl.leftAnchor).isActive = true
        alphaControl.rightAnchor.constraint(equalTo: widthControl.rightAnchor).isActive = true
        alphaControl.topAnchor.constraint(equalTo: widthControl.bottomAnchor, constant: internalPadding).isActive = true
        scaleControl.leftAnchor.constraint(equalTo: heightControl.leftAnchor).isActive = true
        scaleControl.rightAnchor.constraint(equalTo: heightControl.rightAnchor).isActive = true
        scaleControl.topAnchor.constraint(equalTo: heightControl.bottomAnchor, constant: internalPadding).isActive = true
        shiftControl.leftAnchor.constraint(equalTo: spacingControl.leftAnchor).isActive = true
        shiftControl.rightAnchor.constraint(equalTo: spacingControl.rightAnchor).isActive = true
        shiftControl.topAnchor.constraint(equalTo: spacingControl.bottomAnchor, constant: internalPadding).isActive = true

        // control for circle layout - align with width controls
        radiusControl.leftAnchor.constraint(equalTo: widthControl.leftAnchor).isActive = true
        radiusControl.rightAnchor.constraint(equalTo: widthControl.rightAnchor).isActive = true
        radiusControl.topAnchor.constraint(equalTo: widthControl.bottomAnchor, constant: internalPadding).isActive = true

        // controls for bouncy layout - align with width control
        resistanceControl.leftAnchor.constraint(equalTo: widthControl.leftAnchor).isActive = true
        resistanceControl.rightAnchor.constraint(equalTo: widthControl.rightAnchor).isActive = true
        resistanceControl.topAnchor.constraint(equalTo: widthControl.bottomAnchor, constant: internalPadding).isActive = true
        bouncyLevelControl.leftAnchor.constraint(equalTo: resistanceControl.rightAnchor, constant: internalPadding).isActive = true
        bouncyLevelControl.centerYAnchor.constraint(equalTo: resistanceControl.centerYAnchor).isActive = true

        // controls for animated layout - align with generic controls
        moveDirectionControl.leftAnchor.constraint(equalTo: cardCountStepper.leftAnchor).isActive = true
        moveDirectionControl.centerYAnchor.constraint(equalTo: moveDistanceControl.centerYAnchor).isActive = true
        moveDirectionControl.rightAnchor.constraint(equalTo: moveDistanceControl.leftAnchor, constant: -internalPadding).isActive = true
        moveDistanceControl.leftAnchor.constraint(equalTo: widthControl.leftAnchor).isActive = true
        moveDistanceControl.rightAnchor.constraint(equalTo: widthControl.rightAnchor).isActive = true
        moveDistanceControl.topAnchor.constraint(equalTo: widthControl.bottomAnchor, constant: internalPadding).isActive = true
        zoomControl.leftAnchor.constraint(equalTo: heightControl.leftAnchor).isActive = true
        zoomControl.rightAnchor.constraint(equalTo: heightControl.rightAnchor).isActive = true
        zoomControl.topAnchor.constraint(equalTo: heightControl.bottomAnchor, constant: internalPadding).isActive = true
        rotateControl.leftAnchor.constraint(equalTo: spacingControl.leftAnchor).isActive = true
        rotateControl.rightAnchor.constraint(equalTo: spacingControl.rightAnchor).isActive = true
        rotateControl.topAnchor.constraint(equalTo: spacingControl.bottomAnchor, constant: internalPadding).isActive = true

        // collection view
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: aroundPadding).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -aroundPadding).isActive = true
        collectionView.topAnchor.constraint(equalTo: alphaControl.bottomAnchor, constant: internalPadding).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -aroundPadding).isActive = true
    }

    private func performAnimation() {
        guard let direction = AnimationDirection(rawValue: moveDirectionControl.selectedSegmentIndex) else {
            return
        }

        let moveAnimation = AnimationType.from(direction: direction, offset: moveDistanceControl.value)
        let zoomAnimation = AnimationType.zoom(scale: zoomControl.value)
        let rotateAnimation = AnimationType.rotate(angle: rotateControl.value)
        collectionView.reloadData()
        collectionView.performBatchUpdates({
            UIView.animate(views: collectionView.orderedVisibleCells,
                           animations: [moveAnimation, zoomAnimation, rotateAnimation])
        }, completion: nil)
    }

    @objc private func valueChanged(_ sender: UIStepper) {
        let count = Int(sender.value)

        // update label
        cardCountLabel.text = "\(count)"
        // update model
        collectionData.updateCount(count)
    }

    @objc private func bouncyLevelChanged(_ sender: UISegmentedControl) {
        guard let newLevel = BounceStyle(rawValue: sender.selectedSegmentIndex),
            let bouncyLayout = collectionView.collectionViewLayout as? BouncyLayout else {
                return
        }

        bouncyLayout.style = newLevel
        bouncyLayout.invalidateLayout()
    }

    @objc private func directionChanged(_ sender: UISegmentedControl) {
        guard collectionView.collectionViewLayout is AnimatedLayout else {
            return
        }

        performAnimation()
    }
}

extension DetailViewController: CollectionDataModelDelegate {
    func countChanged() {
        collectionView.reloadData()
    }

    func insertCard() {
        collectionView.insertItems(at: [IndexPath(row: collectionData.cardCount() - 1, section: 0)])
    }

    func removeCard() {
        collectionView.deleteItems(at: [IndexPath(row: collectionData.cardCount(), section: 0)])
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.cardCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier,
                                                            for: indexPath) as? CardCell else {
                                                                return UICollectionViewCell()
        }

        cell.cellColor = collectionData.color(at: indexPath.row)
        cell.character = Character.allCases[indexPath.row % Character.allCases.count]
        cell.title = "\(indexPath.row)"

        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {

}

extension DetailViewController: LayoutsModelDelegate {
    func didChangeLayout(to layout: UICollectionViewLayout) {
        // switch option controls
        alphaControl.isHidden = !(layout is AdvancedCarouselLayout)
        scaleControl.isHidden = !(layout is AdvancedCarouselLayout)
        shiftControl.isHidden = !(layout is AdvancedCarouselLayout)
        radiusControl.isHidden = !(layout is CircleLayout)
        resistanceControl.isHidden = !(layout is BouncyLayout)
        bouncyLevelControl.isHidden = !(layout is BouncyLayout)
        moveDirectionControl.isHidden = !(layout is AnimatedLayout)
        moveDistanceControl.isHidden = !(layout is AnimatedLayout)
        zoomControl.isHidden = !(layout is AnimatedLayout)
        rotateControl.isHidden = !(layout is AnimatedLayout)

        // additional configuration
        collectionView.isPagingEnabled = layout is StackLayout

        // configure layout
        configureLayout(layout, width: widthControl.value, height: heightControl.value, spacing: spacingControl.value)

        // change layout with animation
        collectionView.setCollectionViewLayout(layout, animated: true)

        // show detailed description as title
        title = layoutsModel?.currentStyle.detailedDescription()
    }
}

extension DetailViewController: InformativeSliderDelegate {
    func slider(_ slider: InformativeSlider) {
        switch slider {
        case widthControl:
            genericSettingsChanged(width: slider.value)
        case heightControl:
            genericSettingsChanged(height: slider.value)
        case spacingControl:
            genericSettingsChanged(spacing: slider.value)
        case alphaControl:
            alphaChanged(to: slider.value)
        case scaleControl:
            scaleChanged(to: slider.value)
        case shiftControl:
            shiftChanged(to: slider.value)
        case radiusControl:
            radiusChanged(to: slider.value)
        case resistanceControl:
            resistanceChanged(to: slider.value)
        case moveDistanceControl:
            moveDistanceChanged()
        case zoomControl:
            zoomScaleChanged()
        case rotateControl:
            rotateAngleChanged()
        default:
            break
        }
    }

    // generic
    private func genericSettingsChanged(width: CGFloat? = nil, height: CGFloat? = nil, spacing: CGFloat? = nil) {
        configureLayout(collectionView.collectionViewLayout, width: width, height: height, spacing: spacing)

        // invalidate layout
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func configureLayout(_ layout: UICollectionViewLayout, width: CGFloat? = nil, height: CGFloat? = nil, spacing: CGFloat? = nil) {
        if let layout = layout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: width ?? layout.itemSize.width, height: height ?? layout.itemSize.height)
            layout.minimumLineSpacing = spacing ?? layout.minimumLineSpacing
        } else if let circleLayout = layout as? CircleLayout {
            circleLayout.itemSize = CGSize(width: width ?? circleLayout.itemSize.width, height: height ?? circleLayout.itemSize.height)
        } else if let stackLayout = layout as? StackLayout {
            stackLayout.itemSize = CGSize(width: width ?? stackLayout.itemSize.width, height: height ?? stackLayout.itemSize.height)
            stackLayout.spacing = spacing ?? stackLayout.spacing
        } else if let overlapLayout = layout as? OverlapLayout {
            overlapLayout.itemSize = CGSize(width: width ?? overlapLayout.itemSize.width, height: height ?? overlapLayout.itemSize.height)
            overlapLayout.overlapOffset = spacing ?? overlapLayout.overlapOffset
        }
    }

    // advanced carousel
    private func alphaChanged(to newAlpha: CGFloat) {
        guard let advancedCarouselLayout = collectionView.collectionViewLayout as? AdvancedCarouselLayout else {
            return
        }

        advancedCarouselLayout.sideItemAlpha = newAlpha
        advancedCarouselLayout.invalidateLayout()
    }

    private func scaleChanged(to newScale: CGFloat) {
        guard let advancedCarouselLayout = collectionView.collectionViewLayout as? AdvancedCarouselLayout else {
            return
        }

        advancedCarouselLayout.sideItemScale = newScale
        advancedCarouselLayout.invalidateLayout()
    }

    private func shiftChanged(to newShift: CGFloat) {
        guard let advancedCarouselLayout = collectionView.collectionViewLayout as? AdvancedCarouselLayout else {
            return
        }

        advancedCarouselLayout.sideItemShift = newShift
        advancedCarouselLayout.invalidateLayout()
    }

    // circle layout
    private func radiusChanged(to newRadius: CGFloat) {
        guard let circleLayout = collectionView.collectionViewLayout as? CircleLayout else {
            return
        }

        circleLayout.radius = newRadius
        circleLayout.invalidateLayout()
    }

    // bouncy layout
    private func resistanceChanged(to newResistance: CGFloat) {
        guard let bouncyLayout = collectionView.collectionViewLayout as? BouncyLayout else {
            return
        }

        bouncyLayout.resistanceDenominator = newResistance
        bouncyLayout.invalidateLayout()
    }

    // animated layout
    private func moveDistanceChanged() {
        guard collectionView.collectionViewLayout is AnimatedLayout else {
            return
        }

        performAnimation()
    }

    private func zoomScaleChanged() {
        guard collectionView.collectionViewLayout is AnimatedLayout else {
            return
        }

        performAnimation()
    }

    private func rotateAngleChanged() {
        guard collectionView.collectionViewLayout is AnimatedLayout else {
            return
        }

        performAnimation()
    }
}
