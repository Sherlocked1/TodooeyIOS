//Copyright © 2023 Mohammed

import Foundation

extension String {
    
    func getDateStringWithFormat(_ format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let date = formatter.date(from: self) ?? Date()
        
        formatter.dateFormat = format
        formatter.locale = .init(identifier: "en_us")
        return formatter.string(from: date)
    }
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.locale = .init(identifier: "en_us")
        return formatter.date(from: self) ?? Date()
    }
    
    func removeWhitespaces() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
