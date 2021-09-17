//
//  ADSSegmentControlCollectionViewCell.swift
//  AdvancedDesignSystem
//
//  Created by Максим Павлов on 13.06.2021.
//

import UIKit

/// Ячейка(сегмент) коллекции для SegmentedControl
final class ADSSegmentControlCollectionViewCell: UICollectionViewCell {

    // MARK: - Private properties

    /// Фон ячейки
    private let background: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 16
        return background
    }()
    private let configuration = ADSSegmentControl.Configuration.self

    /// Label для отображения заголовка
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = ADSSegmentControl.Configuration.font
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        return titleLabel
    }()

    /// в  ячейке
    private let selectedView: UIView = {
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 2
        selectedView.isHidden = true
        selectedView.translatesAutoresizingMaskIntoConstraints = false

        return selectedView
    }()

    // MARK: - Public properties

    static var reuseIdentifier: String {
        return "ADSSegmentControlCollectionViewCell"
    }

    override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }
            UIView.transition(with: selectedView, duration: 0.3, options: .transitionCrossDissolve) {
                self.background.backgroundColor = self.isHighlighted ? self.configuration.highlightedBackgroundColor : self.configuration.defaultBacgroundColor
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }
            updateAppearance()
        }
    }

    var output: ADSSegmentControlDisplayManagerProtocol?
    var font: UIFont? {
        didSet {
            titleLabel.font = font
        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
            accessibilityLabel = title
        }
    }

    // MARK: - Initializers

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = true
        accessibilityTraits = .button
        backgroundView = background
        contentView.addSubview(titleLabel)

        contentView.addSubview(selectedView)
        setupConstraints()
    }

    // MARK: - Private methods

    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentView.topAnchor.constraint(equalTo: topAnchor),
                                     contentView.leftAnchor.constraint(equalTo: leftAnchor),
                                     contentView.rightAnchor.constraint(equalTo: rightAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     contentView.heightAnchor.constraint(equalToConstant: 56),

                                     titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

                                     selectedView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 18),
                                     selectedView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18),
                                     selectedView.heightAnchor.constraint(equalToConstant: 4.0),
                                     selectedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }

    private func createAnimaion<T>(for keyPath: String,
                                   from startValue: T,
                                   to endValue: T,
                                   with duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = startValue
        animation.toValue = endValue
        animation.duration = duration

        return animation
    }
}

extension ADSSegmentControlCollectionViewCell: ADSSegmentControlCollectionViewCellProtocol {

    func updateAppearance() {
        UIView.transition(with: selectedView, duration: 0.5, options: .curveEaseOut) {
            self.selectedView.isHidden = !self.isSelected
            self.titleLabel.textColor = self.isSelected ? self.configuration.selectedTitleColor : self.configuration.unselectedTitleColor
        }
    }
}

/// Протокол для взаимодействия SegmentedControlDisplayManager с SegmentedControlCollectionViewCell
protocol ADSSegmentControlCollectionViewCellProtocol {

    /// Функция для обновления содержимого ячейки при выборе
    func updateAppearance()
}
