//
//  Builder.swift
//  NewsAppTest
//
//  Created by Alexey Abashin on 19.05.2022.
//

import Foundation

protocol Builder {}

extension NSObject: Builder {}

extension Builder {
    @inlinable public func with(configure: (inout Self) -> Void) -> Self {
        var this = self
        configure(&this)
        return this
    }
}
