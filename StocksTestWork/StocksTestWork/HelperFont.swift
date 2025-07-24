//
//  HelperFont.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 23.07.2025.
//

import Foundation
import UIKit
class HelperFont {
    static func getFont(name: String, size: CGFloat) -> UIFont {
        
        guard let customFont = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        return customFont
    }
}
