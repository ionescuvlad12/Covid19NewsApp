//
//  DynamicValue.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation


class DynamicValue<T>{
   
    typealias CompletionHandler = ((T)->Void)

    private var observers = [String : CompletionHandler]()
    
    var value : T{
        didSet{
            self.notify()
        }
    }
    
    init(value : T) {
        self.value = value
    }
    
    public func addAndNotify(observer : NSObject, completionHandler : @escaping CompletionHandler){
        self.addObserver(observer: observer, completionHandler: completionHandler)
        self.notify()
    }
    
    public func addObserver(observer : NSObject, completionHandler : @escaping CompletionHandler){
        observers[observer.description] = completionHandler
    }
    
    func notify(){
        observers.forEach { (observer) in
            observer.value(value)
        }
    }
    
    deinit {
        observers.removeAll()
    }
}
