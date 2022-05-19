//
//  NewsDateFormatter.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation

enum NewsDateFormatter {
    static let dateInFormatter = DateFormatter().with { $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" }
    static let dateOutFormatter = DateFormatter().with { $0.dateFormat = "MMM d, yyyy" }
    
    static func format(string: String) -> Date? {
        return NewsDateFormatter.dateInFormatter.date(from: string)
    }
    
    static func format(date: Date) -> String {
        return NewsDateFormatter.dateOutFormatter.string(from: date)
    }
}
