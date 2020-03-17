//
//  DataServiceTests.swift
//  Covid19UpdatesTests
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import XCTest
@testable import Covid19Updates

class DataServiceTests: XCTestCase {
    
    func test_CancelRequest() {
        
        // giving a "previous" session
        NewsFetchService.shared.fetchDatafromServer(fromPage: 1, { _ in
             // ignore call
        })
        
        // Expected to task nil after cancel
        NewsFetchService.shared.cancelPreviousTask()
        XCTAssertNil(NewsFetchService.shared.task, "Expected task nil")
    }
}

