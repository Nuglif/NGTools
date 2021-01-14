//
//  Calendar+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2018-04-09.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation

public extension Calendar {

	static var hourTimeInterval: TimeInterval { return 3600 }
    static var minuteTimeInterval: TimeInterval { return 60 }

    private var now: Date { TimeProvider.now() }

    func isToday(of date: Date) -> Bool {
        return isDate(date, inSameDayAs: now)
    }

    func isYesterday(of date: Date) -> Bool {
        guard let yesterday = self.date(byAdding: .day, value: -1, to: now) else { return false }

        return isDate(date, inSameDayAs: yesterday)
    }

    func isSameYear(of date: Date) -> Bool {
        return isDate(date, equalTo: now, toGranularity: .year)
    }

    func isFirstDay(of date: Date) -> Bool {
        return component(.day, from: date) == 1
    }

    func isDayOld(of date: Date) -> Bool {
        return compare(date, to: now, toGranularity: .day) == .orderedAscending
    }

    func isWeekOld(of date: Date) -> Bool {
        return compare(date, to: now, toGranularity: .weekOfYear) == .orderedAscending
    }

    func isBiggerThan(_ interval: TimeInterval, oldDate: Date, newDate: Date) -> Bool {
		let delta = newDate.timeIntervalSince(oldDate)

		return delta > interval
	}

    func isLessThan(_ interval: TimeInterval, oldDate: Date, newDate: Date) -> Bool {
        let delta = newDate.timeIntervalSince(oldDate)

        return delta < interval
    }
}

// MARK: - Needed for Unit test
public struct TimeProvider {

    public static var now: () -> Date = { Date() }
}
