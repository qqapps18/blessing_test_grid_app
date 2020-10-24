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
    var dateComponents: (day: Int?, month: Int?, year: Int?, isLeapYear: Bool)

    switch identifier {
    case .gregorian:
      stringDate = gregorianDate(date: focusDate)
      dateComponents = components(for: focusDate, in: Calendar(identifier: .gregorian))
    case .hebrew:
      stringDate = hebrewDate(date: focusDate)
      dateComponents = components(for: focusDate, in: Calendar(identifier: .hebrew))
    }

    return [
      stringDate,
      dateComponents.day != nil ? String(dateComponents.day!) : "",
      dateComponents.month != nil ? String(dateComponents.month!) : "",
      dateComponents.year != nil ? String(dateComponents.year!) : "",
      String(dateComponents.isLeapYear),
      dateComponents.day != nil ? String(dateComponents.day!) : "",
      dateComponents.month != nil ? String(dateComponents.month!) : "",
      dateComponents.year != nil ? String(dateComponents.year!) : "",
      dateComponents.day != nil ? String(dateComponents.day!) : "",
      dateComponents.month != nil ? String(dateComponents.month!) : "",
      dateComponents.year != nil ? String(dateComponents.year!) : "",
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
    return (day: components.day, month: components.month, year: components.year, isLeapYear: false)
  }
}
