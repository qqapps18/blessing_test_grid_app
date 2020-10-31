//
//  DateFormatterProvider.swift
//  Sidur
//
//  Created by Andrés Pesate on 09/06/2019.
//  Copyright © 2019 Andrés Pesate. All rights reserved.
//

import Foundation

@objc class DateFormatterProvider: NSObject {
  @objc enum Identifier: Int {
    case gregorian
    case hebrew
  }

  private let dayInSeconds: TimeInterval = 60 * 60 * 24

  // MARK: Interface

  /// This method will provide the components and the date for today in the giving identifier calendar
  /// - Parameters:
  ///   - identifier: The calendar to be used. Gregorian, Hebrew.
  ///
  /// - Returns: An array of strings with the following values.
  ///   `[FullDateString, Day, Month, Year, IsLeapYear]`
  @objc func todaysDateComponents(for identifier: Identifier) -> [String] {
    let focusDate = Date()
    var stringDate: String
    var todaysDateComponents: (day: Int?, month: Int?, year: Int?, isLeapYear: Bool)
    var yesterdaysDateComponents: (day: Int?, month: Int?, year: Int?, isLeapYear: Bool)
    var dayBeforeYesterdaysDateComponents: (day: Int?, month: Int?, year: Int?, isLeapYear: Bool)

    switch identifier {
    case .gregorian:
      stringDate = gregorianDate(date: focusDate)
      todaysDateComponents = components(for: focusDate, in: Calendar(identifier: .gregorian))
      yesterdaysDateComponents = components(
        for: focusDate.addingTimeInterval(dayInSeconds * -1),
        in: Calendar(identifier: .gregorian)
      )
      dayBeforeYesterdaysDateComponents = components(
        for: focusDate,
        in: Calendar(identifier: .gregorian)
      )
    case .hebrew:
      stringDate = hebrewDate(date: focusDate)
      todaysDateComponents = components(for: focusDate, in: Calendar(identifier: .hebrew))
      yesterdaysDateComponents = components(
        for: focusDate.addingTimeInterval(dayInSeconds * -1),
        in: Calendar(identifier: .hebrew)
      )
      dayBeforeYesterdaysDateComponents = components(
        for: focusDate.addingTimeInterval(dayInSeconds * -2),
        in: Calendar(identifier: .hebrew)
      )
    }

    return [
      stringDate,
      todaysDateComponents.day != nil ? String(todaysDateComponents.day!) : "",
      todaysDateComponents.month != nil ? String(todaysDateComponents.month!) : "",
      todaysDateComponents.year != nil ? String(todaysDateComponents.year!) : "",
      String(todaysDateComponents.isLeapYear),
      yesterdaysDateComponents.day != nil ? String(yesterdaysDateComponents.day!) : "",
      yesterdaysDateComponents.month != nil ? String(yesterdaysDateComponents.month!) : "",
      yesterdaysDateComponents.year != nil ? String(yesterdaysDateComponents.year!) : "",
      dayBeforeYesterdaysDateComponents
        .day != nil ? String(dayBeforeYesterdaysDateComponents.day!) : "",
      dayBeforeYesterdaysDateComponents
        .month != nil ? String(dayBeforeYesterdaysDateComponents.month!) : "",
      dayBeforeYesterdaysDateComponents
        .year != nil ? String(dayBeforeYesterdaysDateComponents.year!) : "",
    ]
  }

  @objc func todaysDate(for identifier: Identifier) -> String {
    switch identifier {
    case .gregorian: return gregorianDate()
    case .hebrew: return hebrewDate()
    }
  }

  // MARK: Private

  private func gregorianDate(date: Date = .init()) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateStyle = .long
    formatter.timeStyle = .none

    return formatter.string(from: date)
  }

  private func hebrewDate(date: Date = .init()) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .hebrew)
    formatter.dateStyle = .long
    formatter.timeStyle = .none

    return formatter.string(from: date)
  }

  private func components(
    for date: Date = .init(),
    in calendar: Calendar
  ) -> (day: Int?, month: Int?, year: Int?, isLeapYear: Bool) {
    let components = calendar.dateComponents(in: TimeZone.current, from: date)
    var isLeapYear = false

    if let year = components.year {
      isLeapYear = isYearALeapYear(year)
    }

    return (
      day: components.day,
      month: components.month,
      year: components.year,
      isLeapYear: isLeapYear
    )
  }

  private func isYearALeapYear(_ year: Int) -> Bool {
    ((7 * year) + 1) % 19 < 7
  }
}
