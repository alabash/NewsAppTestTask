//
//  ServerService.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation

protocol ServerService {
    func performRequest<T>(_ request: URLRequestable) async throws -> T
}
