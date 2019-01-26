//
//  JSONEncoderExtension.swift
//  Brasileirao
//
//  Created by Fabio Leonardo Barros Martinez on 18/17/18.
//  Copyright © 2018 Fabio Martinez. All rights reserved.
//

import Foundation

extension Decodable {
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(identifier: "UTC")
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try decoder.decode(Self.self, from: data)
    }
}
