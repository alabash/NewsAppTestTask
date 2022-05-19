//
//  NewsModel.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation

struct News {
    let title: String
    let description: String
    let date: Date
    let articleURL: URL
    let imageURL: URL
}

extension News: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case date = "publishedAt"
        case articleURL = "url"
        case imageURL = "urlToImage"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        date = NewsDateFormatter.format(string: try container.decode(String.self, forKey: .date))!
        articleURL = try container.decode(URL.self, forKey: .articleURL)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
    }
}
