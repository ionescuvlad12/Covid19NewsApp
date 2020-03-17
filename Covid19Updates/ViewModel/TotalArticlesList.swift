//
//  TotalArticlesList.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//
//

import Foundation


// holds the updated list after each fetch  response from api

class TotalArticleList{
    static let shared = TotalArticleList()
    
    var loadedArticleList : [News]?
    var totalItems : Int?
    
    init() {
        loadedArticleList = []
        totalItems = 0
    }
    
    func update(with newList : [News], totalResults : Int){
        loadedArticleList?.append(contentsOf: newList)
        totalItems = totalResults
    }
}
