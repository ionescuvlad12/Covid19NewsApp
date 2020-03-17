//
//  ReportAnnotation.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import MapKit

class ReportAnnotation: NSObject, MKAnnotation {
	let report: Report
	let coordinate: CLLocationCoordinate2D
	let title: String?

	init(report: Report) {
		self.report = report
		self.coordinate = report.region.location.clLocation
		self.title = report.region.name

		super.init()
	}
}
