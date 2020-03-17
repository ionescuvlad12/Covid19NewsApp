//
//  VehicleDataSource.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation
import UIKit

class GenericDataSource<T> : NSObject{
    var data : DynamicValue<[T]> = DynamicValue(value: [])
}

class NewsDataSource : GenericDataSource<NewsItemViewModel>, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = data.value[indexPath.row]
        
        if (indexPath.row % 7) == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath)
            
            MainStoryCellConfig.init().configure(cell: cell, data: model)
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 0.3
            return cell

        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath)
            
            NewsCellConfig.init().configure(cell: cell, data: model)
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 0.3
            return cell

        }
        
    }
    
    
    
    
}

