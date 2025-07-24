//
//  PopularSearchCell.swift
//  StocksTestWork
//
//  Created by Dmitriy Mikhaylov on 23.07.2025.
//

import Foundation
import UIKit

class PopularSearchCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(with text: String) {
        self.label.font = UIFont(name: "Montserrat-Medium", size: 12)
        self.label.text = text
        self.contentView.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1)
                    self.layer.cornerRadius = self.frame.size.height / 2
    }
}
