//Copyright © 2023 Mohammed

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.locale = .init(identifier: "en_us")
        return formatter.string(from: self)
    }
}
