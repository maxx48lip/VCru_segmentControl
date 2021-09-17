//
//  ADSSegmentControlDisplayManager.swift
//  AdvancedDesignSystem
//
//  Created by Максим Павлов on 13.06.2021.
//

import Foundation
import UIKit

/// Константы
private enum Constants {
    /// Стандартные отступы ячеек
    static let cellOffsets: CGFloat = 16.0
}

// MARK: - ADSSegmentControlDisplayManagerProtocol

/// Протокол для обратной связи DisplayManager с SegmentedControl
protocol ADSSegmentControlDisplayManagerProtocol: AnyObject {

    /// Сообщить DisplayManager о том, что индекс выбранного сегмента изменился
    func segmentSelected()

    func changeFakeDotFrame(by cellFrame: CGRect)
}

// MARK: - ADSSegmentControlDisplayManager

/// Класс для управления содержимым и поведением SegmentedControl
final class ADSSegmentControlDisplayManager: NSObject {

    // MARK: - Private properties
    
    private let configuration = ADSSegmentControl.Configuration.self
    private let layoutCalculator = ADSSegmentControlLayoutCalculator()

    // MARK: - Public properties

    var titles: [String]
    /// Выбранный индекс сегмента
    var selectedSegmentIndex: Int
    /// Output для взаимодействия
    weak var output: ADSSegmentControlDisplayManagerProtocol?

    // MARK: - Initializers

    /// Создает SegmentedControl с заданными заголоками и выбранным индексом
    ///
    /// - Parameters:
    ///   - titles: Заголовки сегментов
    ///   - selectedSegmentIndex: Индекс выбранного сегмента
    init(titles: [String], selectedSegmentIndex: Int) {
        self.selectedSegmentIndex = selectedSegmentIndex
        self.titles = titles
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFakeDot(_ collectionView: UICollectionView) {
        let indexPath = IndexPath(row: selectedSegmentIndex, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ADSSegmentControlCollectionViewCell else { return }
        output?.changeFakeDotFrame(by: cell.frame)
    }
}

// MARK: - Conformance UICollectionViewDelegate

extension ADSSegmentControlDisplayManager: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        layoutCalculator.calculateSizeForTitlesMode(collectionView: collectionView,
                                                    indexPath: indexPath,
                                                    titles: titles)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedSegmentIndex != indexPath.row {
            selectedSegmentIndex = indexPath.row
            output?.segmentSelected()
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? ADSSegmentControlCollectionViewCell else { return }
        cell.updateAppearance()
        output?.changeFakeDotFrame(by: cell.frame)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ADSSegmentControlCollectionViewCell else { return }
        cell.updateAppearance()
    }
}

// MARK: - Conformance UICollectionViewDataSource

extension ADSSegmentControlDisplayManager: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                                ADSSegmentControlCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ADSSegmentControlCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        guard titles.indices.contains(indexPath.row) else { return cell }
        cell.title = titles[indexPath.row]
        cell.font = configuration.font

        cell.isSelected = selectedSegmentIndex == indexPath.row
        cell.updateAppearance()

        if selectedSegmentIndex == indexPath.row {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        return cell
    }
}
