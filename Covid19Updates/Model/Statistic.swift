//
//  Statistic.swift
//  Covid19Updates
//
//  Created by Vlad Ionescu on 17/03/2020.
//  Copyright © 2020 Vlad Ionescu. All rights reserved.
//

import Foundation

public struct Statistic: Codable {
	public let confirmedCount: Int
	public let recoveredCount: Int
	public let deathCount: Int
	public var activeCount: Int { confirmedCount - recoveredCount - deathCount }

	public var recoveredPercent: Double { confirmedCount == 0 ? 0 : 100.0 * Double(recoveredCount) / Double(confirmedCount) }
	public var deathPercent: Double { confirmedCount == 0 ? 0 :  100.0 * Double(deathCount) / Double(confirmedCount) }
	public var activePercent: Double { confirmedCount == 0 ? 0 :  100.0 * Double(activeCount) / Double(confirmedCount) }

	public var confirmedCountString: String { NumberFormatter.groupingFormatter.string(from: NSNumber(value: confirmedCount))! }
	public var recoveredCountString: String { NumberFormatter.groupingFormatter.string(from: NSNumber(value: recoveredCount))! }
	public var deathCountString: String { NumberFormatter.groupingFormatter.string(from: NSNumber(value: deathCount))! }
}

extension Statistic: CustomStringConvertible {
	public var description: String {
		"""
		Confirmed: \(confirmedCountString)
		Recovered: \(recoveredCountString) (\(recoveredPercent.percentFormatted))
		Deaths: \(deathCountString) (\(deathPercent.percentFormatted))
		"""
	}
}

extension Statistic {
	public static func join(subData: [Statistic]) -> Statistic {
		Statistic(confirmedCount: subData.reduce(0) { $0 + $1.confirmedCount },
				  recoveredCount: subData.reduce(0) { $0 + $1.recoveredCount },
				  deathCount: subData.reduce(0) { $0 + $1.deathCount })
	}
}
