//
//  RequestFactory.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//


import Foundation

final class RequestFactory{
    
    enum Method : String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }

    
    static func request(method : Method, url : URL, query: String) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let jsonData : [String: Any] = ["operationName": "createFeed",
                                  "variables": ["url":query],
                                  "query":"mutation createFeed($url: String, $simulate: Boolean, $scrapingRules: ScrapingRulesInput, $requestObject: RequestObjectInput) {\n  createFeed(url: $url, simulate: $simulate, scrapingRules: $scrapingRules, requestObject: $requestObject) {\n    title\n    description\n    feedUrl\n    siteUrl\n    siteName\n    imageUrl\n    generator\n    items {\n      title\n      url\n      description\n      date\n      enclosure {\n        url\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n"]
        let json = try? JSONSerialization.data(withJSONObject: jsonData)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  
        request.httpBody = json
        return request
    }
}
