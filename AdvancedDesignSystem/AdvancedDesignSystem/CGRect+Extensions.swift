//
//  CGRect+Extensions.swift
//  AdvancedDesignSystem
//
//  Created by Максим Павлов on 13.06.2021.
//

import UIKit

extension CGRect {
    /// Инциализатор квадрата
    /// - Parameters:
    ///   - x: origin.x
    ///   - y: origin.y
    ///   - widthAndHeight: размер стороны квадрата
    init(x: CGFloat, y: CGFloat, widthAndHeight: CGFloat) {
        self.init(x: x, y: y, width: widthAndHeight, height: widthAndHeight)
    }
}
