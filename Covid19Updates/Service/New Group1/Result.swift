//
//  Result.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation

enum Result<T, E : Error>{
    case success(T)
    case failure(E)
}
