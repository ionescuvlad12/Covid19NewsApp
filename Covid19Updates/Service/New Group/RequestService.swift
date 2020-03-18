//
//  RequestService.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//


import Foundation


// Protocol for MOCK/Real
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol
}

protocol URLSessionTaskProtocol {
    func resumeTask()
}



final class RequestService {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    
    func requestDataFromServer(urlstring : String, query: String, completion : @escaping (Result<Data, ErrorResult>)->Void)->URLSessionTask?{
        
        guard let url = URL(string: urlstring) else {
            completion(.failure(.network(string: "invalid url")))
            return nil
        }
        
        var request = RequestFactory.request(method: .POST, url: url, query: query)
        
        if let reachability = Reachability(), !reachability.isReachable{
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                completion(Result.failure(ErrorResult.network(string: "error occured while requesting : \(error)")))
                return
            }
            
            if let data = data{
                completion(Result.success(data))
                if data.count < 500 {
                    DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("errorLoading"), object: nil)
                    }
                }
            }
        }
        task.resumeTask()
        return task as? URLSessionTask
    }
}


//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionTaskProtocol
    {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionTask
    }
}

extension URLSessionTask: URLSessionTaskProtocol {
    func resumeTask (){
        self.resume()
    }
}
