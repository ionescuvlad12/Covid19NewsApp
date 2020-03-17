//
//  NewsListViewModelTests.swift
//  Covid19UpdatesTests
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import XCTest

@testable import Covid19Updates

class NewsListViewModelTests : XCTestCase {
    
    var viewModel : NewsListViewModel!
    var dataSource : GenericDataSource<NewsItemViewModel>!
    var dataService : MockDataService!
    
    
    override func setUp() {
        super.setUp()
        self.dataService = MockDataService()
        self.dataSource = GenericDataSource<NewsItemViewModel>()
        self.viewModel = NewsListViewModel(service: dataService, dataSource: dataSource)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.dataSource = nil
        self.dataService = nil
        super.tearDown()
    }
    
    func test_FetchData_WithoutService(){
        let expectation = XCTestExpectation(description: "No service found")
        let pageNumber = 1

        // not setting service in the view model
        viewModel.service = nil
        
        // expected to not be able to fetch currencies
        viewModel.errorResult = { error in
            expectation.fulfill()
        }
        
        viewModel.fetchData(fromPage: pageNumber)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FetchData(){
        
        let expectation = XCTestExpectation(description: "Data fetch")
        let pageNumber = 1
        
        //mocking service with a list of 1 item
        let list = [News.init(dictionary: [String:AnyObject]())]
        let mockArticles = Articles(articleList: list, totalArticles: 1)
        dataService.articles = mockArticles

        dataSource.data.addObserver(observer: self) { _ in
            expectation.fulfill()
        }
        viewModel.fetchData(fromPage: pageNumber)
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func test_FetchNoData(){
        
        let expectation = XCTestExpectation(description: "Not Data fetch")
        let pageNumber = 1
        
        //no list of articles
        
        dataService.articles = nil
        
        // expected completion to fail
        viewModel.errorResult = { error in
            expectation.fulfill()
        }
        
        viewModel.fetchData(fromPage: pageNumber)
        wait(for: [expectation], timeout: 5.0)
        
    }

}


class MockDataService : DataFetchServiceProtocol {
    
    var articles : Articles?
    func fetchDatafromServer(fromPage number: Int, _ completion: @escaping ((Result<Articles, ErrorResult>) -> Void)) {
        
        if let fetchedList = articles{
            completion(Result.success(fetchedList))
        }else{
            completion(Result.failure(ErrorResult.custom(string: "No data received")))
        }
        
    }
    
    
}
