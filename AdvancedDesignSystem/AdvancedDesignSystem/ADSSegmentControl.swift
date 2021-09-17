//
//  ADSSegmentControl.swift
//  AdvancedDesignSystem
//
//  Created by Максим Павлов on 13.06.2021.
//

import Foundation
import UIKit

final public class ADSSegmentControl: UIControl {

    // MARK: - Public properties

    public var selectedSegmentIndex: Int {
        get {
            return displayManager.selectedSegmentIndex
        }
        set {
            displayManager.selectedSegmentIndex = newValue
            let newIndexPath = IndexPath(row: newValue, section: 0)
            guard !titles.isEmpty else { return }
            collectionView.selectItem(at: newIndexPath, animated: true, scrollPosition: .centeredVertically)
            // Анимируем появление полосочки выделения через короткое время после отрисовки
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.displayManager.setupFakeDot(self.collectionView)
            }
        }
    }

    /// Заголовки
    public var titles: [String] {
        didSet {
            displayManager.titles = titles
            collectionView.reloadData()
            collectionView.performBatchUpdates(nil, completion: nil)
            displayManager.setupFakeDot(self.collectionView)
        }
    }

    // MARK: - Private properties

    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.isUserInteractionEnabled = false

        return backgroundView
    }()
    
    private let animatedDotView: UIView = {
        let animatedDotView = UIView(frame: .init(x: 0, y: 56, widthAndHeight: Configuration.animatedDotViewHeight))
        animatedDotView.isUserInteractionEnabled = false
        animatedDotView.layer.cornerRadius = Configuration.animatedDotViewHeight / 2
        animatedDotView.backgroundColor = Configuration.animatedDotViewColor
        return animatedDotView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: CGRect.zero,
                                              collectionViewLayout: collectionViewFlowLayout)
        return collectionView
    }()

    private lazy var displayManager: ADSSegmentControlDisplayManager = {
        let displayManager = ADSSegmentControlDisplayManager(titles: titles, selectedSegmentIndex: 0)
        displayManager.output = self

        return displayManager
    }()

    // MARK: - Initializers

    override convenience init(frame: CGRect) {
        self.init()
        self.frame = frame
    }

    /// Инициализирует элемент для переключения между вкладками с настроенными параметрами
    /// отображения в соответствии с указанным стилем.
    convenience public init() {
        self.init(titles: [], selectedSegmentIndex: Int.zero)
    }

    /// Инициализирует элемент для переключения между вкладками с настроенными параметрами
    /// отображения в соответствии с указанным стилем и заголовком.
    /// - Parameter title: Текст, отображаемый на кнопке.
    public init(titles: [String], selectedSegmentIndex: Int) {

        self.titles = titles
        super.init(frame: .zero)

        setupCollection()

        self.selectedSegmentIndex = selectedSegmentIndex
        addSubview(backgroundView)
        addSubview(collectionView)
        createConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriding

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 56)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Create UI

    private func setupCollection() {
        collectionView.delegate = displayManager
        collectionView.dataSource = displayManager
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = backgroundColor
        collectionView.bounces = false
        collectionView.addSubview(animatedDotView)
        collectionView.register(ADSSegmentControlCollectionViewCell.self,
                                forCellWithReuseIdentifier: ADSSegmentControlCollectionViewCell.reuseIdentifier)
    }

    private func createConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
                                     backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
                                     backgroundView.topAnchor.constraint(equalTo: topAnchor),
                                     backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
                                     collectionView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
                                     collectionView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
            ])
    }
}

// MARK: - Conformance SegmentedControlDisplayManagerProtocol

extension ADSSegmentControl: ADSSegmentControlDisplayManagerProtocol {
    func segmentSelected() {
        sendActions(for: .valueChanged)
    }

    func changeFakeDotFrame(by cellFrame: CGRect) {
        let toFrame: CGRect = .init(
            x: cellFrame.minX + Configuration.animatedDotViewInset,
            y: cellFrame.maxY - Configuration.animatedDotViewHeight,
            width: cellFrame.width - Configuration.animatedDotViewInset * 2,
            height: Configuration.animatedDotViewHeight)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.animatedDotView.frame = toFrame
        }
    }
}
