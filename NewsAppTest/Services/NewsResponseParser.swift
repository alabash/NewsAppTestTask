//
//  NewsResponseParser.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation

protocol NewsAPIResponseParserProtocol {
    func parseNews(data: Data) throws -> [News]
}

class NewsAPIResponseParser: NewsAPIResponseParserProtocol {
    
    private let decoder = JSONDecoder()
    
    func parseNews(data: Data) throws -> [News] {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                throw ParserError.invalidResponseDataType
            }
            
            guard let status = json["status"] as? String, status == "ok" else {
                throw ParserError.invalidResponseDataType
            }
            
            guard let articles = json["articles"] as? [Any] else {
                throw ParserError.invalidResponseDataType
            }
            
            let articlesData = try JSONSerialization.data(withJSONObject: articles, options: [])
            let parsedResponse = try decoder.decode([News].self, from: articlesData)
            return parsedResponse
        } catch {
            throw ParserError.invalidResponseDataType
        }
    }
}

extension NewsAPIResponseParser {
    enum ParserError: Error {
        case invalidResponseDataType
    }
}

extension NewsAPIResponseParser.ParserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponseDataType:
            return "Parser Error"
        }
    }
}
