//
//  Error.swift
//  
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation

enum ErrorResult : Error {
    case network(string : String)
    case parser(string:String)
    case custom(string:String)
}
