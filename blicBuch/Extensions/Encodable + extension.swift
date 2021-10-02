//
//  Encodable + extension.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 29.8.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

extension Encodable {
    
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: AnyObject] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: AnyObject] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
