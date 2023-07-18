//
//  Constants.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import UIKit

enum Weekdays: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

}

enum Constants {

    static func getCurrentWeekdayRussian() -> String {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let weekdaySymbols = calendar.weekdaySymbols.map { $0.localizedCapitalized }
        let weekdaySymbol = weekdaySymbols[weekday - 1]
        return weekdaySymbol
    }


    static func getCurrentWeekdayEnglish() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        let weekdaySymbols = calendar.weekdaySymbols.map { $0.localizedLowercase }
        let weekdaySymbol = weekdaySymbols[weekday - 1]

        switch weekdaySymbol {
        case "sun":
            return Weekdays.sunday.rawValue
        case "mon":
            return Weekdays.monday.rawValue
        case "tue":
            return Weekdays.tuesday.rawValue
        case "wed":
            return Weekdays.wednesday.rawValue
        case "thu":
            return Weekdays.thursday.rawValue
        case "fri":
            return Weekdays.friday.rawValue
        case "sat":
            return Weekdays.saturday.rawValue
        default:
            break
        }
        return weekdaySymbol
    }

    static let screen = UIScreen.main.bounds
    static let cornerRadius = 8.0
    static let weekdayUrl = "http://84.38.181.162/ios/\(getCurrentWeekdayEnglish()).json"
    static let askUrl = "http://84.38.181.162/ios/ask.php"
    static let responseUrl = "http://84.38.181.162/ios/response.php?id="
}

enum NetworkError: String, Error {
    case invalidURL = "Invalid URL"
    case invalidResponse = "Invalid Response"
    case statusCode = "Status Code Not OK"
    case noData = "No Data"
    case decodingError = "Decoding Error"
    case invalidData = "Invalid Data"
}
