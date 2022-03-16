//
//  CafeQuestionsFetchRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/16.
//

import Foundation

struct CafeQuestionsFetchRequestDTO: Encodable {
    let page: Int
    let size: Int
    
    func toDictionary() -> [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
