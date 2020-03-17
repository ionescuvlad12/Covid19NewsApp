//
//  CellConfugurator.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
// Reference:https://medium.com/chili-labs/configuring-multiple-cells-with-generics-in-swift-dcd5e209ba16

import UIKit
import Foundation

protocol ConfigurableCell {
    associatedtype DataType
    func configureCell(with data : DataType)
}

protocol CellConfigurator {
    associatedtype DataType
    
    static var reuseId: String { get }
    func configure(cell: UIView, data : DataType)
}

class NewsCollectionCellConfigurator<CellType : ConfigurableCell, DataType> : CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell{
    
    static var reuseId: String { return String(describing: CellType.self) }
    
    func configure(cell: UIView, data: DataType) {
        (cell as! CellType).configureCell(with: data)
    }
    
    
}

