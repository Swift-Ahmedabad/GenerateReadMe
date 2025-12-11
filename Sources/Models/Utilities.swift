//
//  File.swift
//  GenerateReadMe
//
//  Created by Ratnesh Jain on 18/11/25.
//

import Foundation

extension String {
    /// Parses a date from the string by extracting the substring after the last ". "
    /// and interpreting it with the "MMM dd, yyyy" format (e.g., "Nov 18, 2025").
    /// - Returns: A `Date` if the substring can be parsed using the expected format; otherwise, `nil`.
    public var date: Date? {
        if let last = self.split(separator: ". ").last {
            let dateString = String(last)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.date(from: dateString)
        }
        return nil
    }
}

extension Date {
    public func addingTime(from date: Date) -> Date {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}
