//
//  NewsService.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation

protocol URLRequestable {
    func makeURLRequest() -> URLRequest
}

enum NewsRouter {
    static let base: String = "https://newsapi.org/v2"
    
    case featured
    case feed
}

extension NewsRouter: URLRequestable {
    func makeURLRequest() -> URLRequest {
        let relativePath: String = {
            switch self {
            case .featured:
                return "top-headlines"
            case .feed:
                return "everything"
            }
        }()
        
        let url: URL = URL(string: NewsRouter.base)!.appendingPathComponent(relativePath)
        
        var params: [URLQueryItem] = [URLQueryItem(name: "apiKey", value: "3694dad9cbc345c3b86afe90fe329cca")]
        
        switch self {
        case .featured:
            params.append(URLQueryItem(name: "country", value: "us"))
            params.append(URLQueryItem(name: "pageSize", value: "1"))
        case .feed:
            params.append(URLQueryItem(name: "domains", value: "techcrunch.com"))
            params.append(URLQueryItem(name: "sortBy", value: "popularity"))
        }
        
        var components = URLComponents(string: url.absoluteString)!
        components.queryItems = params
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
}

class NewsService: ServerService {
    
    private let session: URLSession
    private let parser: NewsAPIResponseParserProtocol

    init(session: URLSession = URLSession(configuration: .default), parser: NewsAPIResponseParserProtocol = NewsAPIResponseParser()) {
        self.session = session
        self.parser = parser
    }
    
    internal func performRequest<T>(_ request: URLRequestable) async throws -> T {
        let (data, _) = try await session.data(for: request.makeURLRequest())
        
        guard let data = data as? T else {
            throw HTTPRequestError.invalidResponseDataType
        }
        
        return data
    }
}

extension NewsService {
    func getAllNews() async throws -> [News] {
        let data: Data = try await performRequest(NewsRouter.feed)
        let result = try parser.parseNews(data: data)
        return result
    }
    
    func getFeaturedNews() async throws -> News {
        let data: Data = try await performRequest(NewsRouter.featured)
        let result = try parser.parseNews(data: data).first!
        return result
    }
}

extension NewsService {
    enum HTTPRequestError: Error {
        case invalidResponseDataType
        case custom(String)
    }
}

extension NewsService.HTTPRequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponseDataType:
            return "Response's data format is different from expected."
        case .custom(let value):
            return value
        }
    }
}
