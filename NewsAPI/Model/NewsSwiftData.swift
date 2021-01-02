//
//  NewsSwiftData.swift
//  NewsAPI
//
//  Created by Amit Chaudhary on 11/28/20.
//  Copyright © 2020 Amit Chaudhary. All rights reserved.
//

import Foundation
import UIKit

class NewsSwiftData: Codable {
    let id: String?
    let date: String?
    let type: String?
    let data: String?
}

struct SwiftDataDelete: Codable {
    let id: String?
    let date: String?
    let type: String?
    let data: String?
}

struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

struct FailableCodableArray<Element : Codable> : Codable {

    var elements: [Element]

    init(from decoder: Decoder) throws {

        var container = try decoder.unkeyedContainer()

        var elements = [Element]()
        if let count = container.count {
            elements.reserveCapacity(count)
        }

        while !container.isAtEnd {
             let element = try container
                .decode(FailableDecodable<Element>.self).base
                elements.append(element!)
        }

        self.elements = elements
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(elements)
    }
}

