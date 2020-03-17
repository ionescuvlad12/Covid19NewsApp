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
    
    func fetchDatafromServer(fromPage number : Int, _ completion: @escaping ((Result<Articles, ErrorResult>) -> Void)) {
        
        let key = "bd05112cec824209913198a603d414c6"
        let pageSize = 21
        let region = ""
        let language = "ro"
        let endpoint = "https://newsapi.org/v2/everything?q=((%22coronavirus%22%20OR%20%22covid%22)%20AND%20%22\(region)%22)&language=\(language)&sortBy=publishedAt&apiKey=\(key)&page=\(number)&pageSize=\(pageSize)"
        
        self.cancelPreviousTask()
        
         task = RequestService(session: URLSession(configuration: .default)).requestDataFromServer(urlstring: endpoint, completion: self.networkResponse(completion: completion))
        
    }
    
    func cancelPreviousTask(){
        if let task = task{
            task.cancel()
        }
        task = nil
    }
}
