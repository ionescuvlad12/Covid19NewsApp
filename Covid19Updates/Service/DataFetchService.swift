//
//  DataFetchService.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation

protocol DataFetchServiceProtocol : class{
    
    func fetchDatafromServer(fromPage number : Int, _ completion: @escaping ((Result<Articles, ErrorResult>) -> Void))
}

final class NewsFetchService : ResponseHandler, DataFetchServiceProtocol{

    static let shared = NewsFetchService()
    
    let dateToday = Date()
    
    var task : URLSessionTask?
    
    var region = ""
    var language = Locale.current.languageCode!
    
    func fetchDatafromServer(fromPage number : Int, _ completion: @escaping ((Result<Articles, ErrorResult>) -> Void)) {
        region = region.replacingOccurrences(of: " ", with: "+")
        let endpoint = "https://rss.app/graphql"
        var query = "https://news.google.com/search?q=coronavirus+\(region)&gl=\(language)"
        if region.isEmpty {
            query = "https://news.google.com/search?q=coronavirus&hl=\(language)"
        }
        
        self.cancelPreviousTask()
        
        task = RequestService(session: URLSession(configuration: .default)).requestDataFromServer(urlstring: endpoint, query: query, completion: self.networkResponse(completion: completion))
        
    }
    
    func cancelPreviousTask(){
        if let task = task{
            task.cancel()
        }
        task = nil
    }
}
