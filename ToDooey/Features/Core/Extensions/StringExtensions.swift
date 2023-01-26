//Copyright © 2023 Mohammed

import Foundation

extension String {
    
    ///formats the string to a date with the specified format
    ///the input string must be formatted with a "dd-MM-yyyy HH:mm:ss" format
    ///- parameters format : output date format
    func getDateStringWithFormat(_ format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let date = formatter.date(from: self) ?? Date()
        
        formatter.dateFormat = format
        formatter.locale = .init(identifier: "en_us")
        return formatter.string(from: date)
    }
    
    ///convert the string to a Date object
    ///the string must be formatted with a "dd-MM-yyyy HH:mm:ss" format
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.locale = .init(identifier: "en_us")
        return formatter.date(from: self) ?? Date()
    }
    
    ///Trims whitespaces and new lines from both sides of a string
    func removeWhitespaces() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
