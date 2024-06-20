//
//  UtillsExtensions.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 06/06/2024.
//

import Foundation

extension String {

    func getYear() -> String? {
    // Create a DateFormatter object specifying the input date format and locale
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set to US English (POSIX)

    // Convert the string to a Date object (handle potential conversion error)
    guard let date = dateFormatter.date(from: self) else {
      return nil
    }

    // Create a calendar object
    let calendar = Calendar.current

    // Extract the year component from the date
    let year = calendar.component(.year, from: date)

        return String(year)
  }
}
