//
//  BasicCollectionViewCell+extension.swift
//  Weather Report
//
//  Created by Jan Sebastian on 31/03/22.
//

import Foundation
import CellTemplates

extension BasicCollectionViewCell {
    func setValue(menu text: String) {
        self.getLblTitle().text = text
        self.backgroundColor = .black
//        self.contentView.backgroundColor = .black
        self.getLblTitle().textColor = .white
    }
}
