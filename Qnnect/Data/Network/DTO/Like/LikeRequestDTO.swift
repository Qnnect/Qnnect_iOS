//
//  LikeRequestDTO.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/15.
//

import Foundation

struct LikeRequestDTO: Encodable {
    let isUserLiked: Bool
    
    func toDictionary() -> [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
