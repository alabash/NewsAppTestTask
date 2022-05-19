//
//  SimpleImageLoader.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation
import UIKit

class SimpleImageLoader {
    class func loadImageFrom(urlString: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: urlString)
        return UIImage(data: data)
    }
}
