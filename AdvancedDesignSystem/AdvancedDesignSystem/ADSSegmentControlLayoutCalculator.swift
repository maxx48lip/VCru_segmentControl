//
//  ADSSegmentControlLayoutCalculator.swift
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

final class ADSSegmentControlLayoutCalculator {
    private var titles: [String] = []
    private let font = ADSSegmentControl.Configuration.font

    private var state: State {
        titles.count > 2 ? .scrollable : .nonscrollable
    }

    /// Тип отображения SegmentedControl
    private enum State {
        case nonscrollable
        case scrollable
    }

    func calculateSizeForTitlesMode(collectionView: UICollectionView, indexPath: IndexPath, titles: [String]) -> CGSize {
        self.titles = titles
        if state == .scrollable {
            let titlesString = titles.reduce("", +)
            let titlesWidth = titlesString.size(withAttributes: [.font: font]).width
            let nonScrolableOffsets = CGFloat(titles.count) * Constants.cellOffsets
            let isCorrectWidth = titlesWidth + nonScrolableOffsets > collectionView.bounds.width

            return isCorrectWidth
                ? calculateSizeForScrollableCollectionCell(collectionView: collectionView, indexPath: indexPath)
                : calculateSizeForNonScrollableCollectionCell(collectionView: collectionView, indexPath: indexPath,
                                                              titlesWidth: titlesWidth)
        }
        return calculateSizeForNonScrollableControlCell(collectionView: collectionView, indexPath: indexPath)
    }
}

private extension ADSSegmentControlLayoutCalculator {

    func calculateSizeForNonScrollableCollectionCell(collectionView: UICollectionView, indexPath: IndexPath,
                                                         titlesWidth: CGFloat) -> CGSize {
        let correctOffset: CGFloat = (collectionView.bounds.width - titlesWidth) / CGFloat(titles.count)
        let titleSize = titles[indexPath.row].size(withAttributes: [.font: font])
        return CGSize(width: titleSize.width + correctOffset, height: collectionView.bounds.height)
    }

    func calculateSizeForScrollableCollectionCell(collectionView: UICollectionView,
                                                          indexPath: IndexPath) -> CGSize {
        let offsets: CGFloat = Constants.cellOffsets
        let title = titles[indexPath.row]
        let titleSize = title.size(withAttributes: [.font: font])
        return CGSize(width: titleSize.width + offsets, height: collectionView.bounds.height)
    }

    func calculateSizeForNonScrollableControlCell(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        //Деление на части пропорционально длинне слов
//        let titlesString = titles.reduce("", +)
//        let titlesWidth = titlesString.size(withAttributes: [.font: configuration.font]).width
//        let correctOffset: CGFloat = (collectionView.bounds.width - titlesWidth) / CGFloat(titles.count)
//        let titleSize = titles[indexPath.row].size(withAttributes: [.font: configuration.font])
//        return CGSize(width: titleSize.width + correctOffset, height: collectionView.bounds.height)
        //Деление на равные части (Алгоритм Нат)
        let count = titles.count
        let correctWidth: CGFloat = collectionView.bounds.width / CGFloat(count)
        return CGSize(width: correctWidth, height: collectionView.bounds.height)
    }
}
