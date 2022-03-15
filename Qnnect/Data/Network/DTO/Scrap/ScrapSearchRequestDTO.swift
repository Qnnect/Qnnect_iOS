//
//  ScrapSearchRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation

struct ScrapSearchRequestDTO: Encodable {
    let page: Int
    let size: Int
    let searchWord: String
    
    func toDictionary() -> [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
