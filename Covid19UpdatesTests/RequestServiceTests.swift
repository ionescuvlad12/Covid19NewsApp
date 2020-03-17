//
//  RequestServiceTests.swift
//  Covid19UpdatesTests
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import XCTest

@testable import Covid19Updates

class RequestServiceTests : XCTestCase{
    
    var requestService : RequestService!
    var session = MockUrlSession()
    typealias completeClosure = (Result<Data, ErrorResult>)->Void
    let url = "https://mock.com"

    override func setUp() {
        super.setUp()
        
        requestService = RequestService(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        
        requestService = nil
    }
    
    
    func test_RequestDataWithURL(){

        _ = requestService.requestDataFromServer(urlstring: url) { _ in
            
            //success
        }
        
        XCTAssert(session.lastURL == URL(string: url))

    }
    
    func test_TaskResumeCalled() {
        
        let dataTask = MockUrlSessionTask()
        session.nextDataTask = dataTask
        
        _ = requestService.requestDataFromServer(urlstring: url) { _ in
            
            //success
        }
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func test_RequestShouldReturnData() {
        let expectedData = "{}".data(using: .utf8)
//        let expectation = XCTestExpectation(description: "Not Data fetch")

        session.nextData = expectedData
        
        var actualData: Data?

        _ = requestService.requestDataFromServer(urlstring: url) { response in
//            expectation.fulfill()

            switch response {
            case .success(let data):
                    actualData = data
                    break;
            case .failure(_):
                    break
            }
        }
//        wait(for: [expectation], timeout: 5.0)

        XCTAssertNotNil(actualData)
    }
    
}






//MARK:- Mock Objects


class MockUrlSession : URLSessionProtocol{
    
    var nextDataTask = MockUrlSessionTask()
    var nextData: Data?
    var nextError: Error?
    private (set) var lastURL: URL?

    func mockSuccessURLResponse(request: URLRequest)->URLResponse{
        return URLResponse(url: request.url!, mimeType: "", expectedContentLength: 50, textEncodingName: "")
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol {
        
        lastURL = request.url
        completionHandler(nextData, mockSuccessURLResponse(request: request), nextError)
        return nextDataTask
    }
}


class MockUrlSessionTask : URLSessionTaskProtocol {
    
    private (set) var resumeWasCalled = false

    func resumeTask (){
        
        resumeWasCalled = true
    }
}
