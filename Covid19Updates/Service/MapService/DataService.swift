//
//  DataService.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation

public protocol DataService {
	typealias FetchListBlock<T> = ([T]?, Error?) -> Void
	typealias FetchReportsBlock = FetchListBlock<Report>
	typealias FetchTimeSeriesesBlock = FetchListBlock<TimeSeries>

	func fetchReports(completion: @escaping FetchReportsBlock)

	func fetchTimeSerieses(completion: @escaping FetchTimeSeriesesBlock)
}
