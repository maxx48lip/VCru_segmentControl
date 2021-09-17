//
//  ADSSegmentControlConfiguration.swift
//  AdvancedDesignSystem
//
//  Created by Максим Павлов on 13.06.2021.
//

import UIKit

extension ADSSegmentControl {
    // По-хорошему надо сделать не статикой, а то новых конфигураций не добавить
    struct Configuration {
        static let selectedTitleColor: UIColor = .blue
        static let unselectedTitleColor: UIColor = .black
        static let highlightedBackgroundColor: UIColor = .clear.withAlphaComponent(0.03)
        static let defaultBacgroundColor: UIColor = .clear
        static let selectedViewColor: UIColor = .red
        static let font = UIFont.systemFont(ofSize: 16)
        static let animatedDotViewHeight: CGFloat = 4
        static let animatedDotViewColor: UIColor = .pink
        static let animatedDotViewInset: CGFloat = 14
    }
}
