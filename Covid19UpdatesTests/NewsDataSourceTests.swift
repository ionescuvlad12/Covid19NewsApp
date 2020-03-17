//
//  NewsDataSourceTests.swift
//  Covid19UpdatesTests
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import XCTest
@testable import Covid19Updates

class NewsDataSourceTests : XCTestCase{
    
    var dataSource : NewsDataSource!
    
    override func setUp() {
        super.setUp()
        
        dataSource = NewsDataSource()
    
    }
    
    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }
    
    func test_EmptyValueInDataSource() {
        
        // giving empty data value
        dataSource.data.value = []
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: layout)
            collectionView.dataSource = dataSource
        
        // expected zero items
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 0, "Expected no items")
        
    }
    
    
    func test_ValueInDataSource() {
        
        let story1 = NewsItemViewModel.init(news: News(dictionary : [String:AnyObject]()))
        let story2 = NewsItemViewModel.init(news: News(dictionary : [String:AnyObject]()))
        
        
        dataSource.data.value = [story1, story2]
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: 300, height: 300), collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        
        // expected zero items
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 2, "Expected 2 items in the collection")
    }
}
