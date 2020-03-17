//
//  RequestHandler.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//


import Foundation

class ResponseHandler {
    
    func networkResponse<T:Parceable>(completion : @escaping ((Result<[T], ErrorResult>)->Void))->((Result<Data, ErrorResult>)->Void){
        
        return {   response in
            DispatchQueue.global(qos: .background).async {
                switch response {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    break
                case .failure(let error) :
//                    print("Network error \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                    break
                }
                
            }
            
        }
        
    }
    
    func networkResponse<T:Parceable>(completion : @escaping ((Result<T, ErrorResult>)->Void))->((Result<Data, ErrorResult>)->Void){
        
        return {   response in
            DispatchQueue.global(qos: .background).async {
                switch response {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    break
                case .failure(let error) :
//                    print("Network error \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                    break
                }
                
            }
            
        }
        
    }
}
