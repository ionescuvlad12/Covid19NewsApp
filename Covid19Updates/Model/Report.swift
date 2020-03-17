//
//  Report.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import MapKit

public struct Report: Codable {
	public var region: Region
	public let lastUpdate: Date
	public let stat: Statistic
}

extension Report {
	static func join(subReports: [Report]) -> Report {
		Report(region: Region.join(subRegions: subReports.map { $0.region }),
			   lastUpdate: subReports.max { $0.lastUpdate < $1.lastUpdate }!.lastUpdate,
			   stat: Statistic.join(subData: subReports.map { $0.stat }))
	}
}
