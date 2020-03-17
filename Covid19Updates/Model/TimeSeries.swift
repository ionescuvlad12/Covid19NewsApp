//
//  TimeSeries.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import MapKit

public struct TimeSeries: Codable {
	public var region: Region
	public let series: [Date : Statistic]
}

extension TimeSeries {
	static func join(subSerieses: [TimeSeries]) -> TimeSeries {
		assert(!subSerieses.isEmpty)

		let region = Region.join(subRegions: subSerieses.map { $0.region })

		var series: [Date : Statistic] = [:]
		let subSeries = subSerieses.first!
		subSeries.series.keys.forEach { key in
			let subData = subSerieses.compactMap { $0.series[key] }
			let superData = Statistic.join(subData: subData)
			series[key] = superData
		}

		return TimeSeries(region: region, series: series)
	}
}
