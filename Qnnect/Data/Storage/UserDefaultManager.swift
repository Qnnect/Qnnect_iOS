//
//  AuthUseDefaultManager.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation

enum LoginType: String,Codable {
    case kakao
    case apple
}

protocol UserDefaultManager: AnyObject {
    var token: (access: String, refresh: String, type: LoginType)? { get set }
    var isFirstAccess: Bool? { get set }
}

final class DefaultUserDefaultManager: UserDefaultManager {
    
    var token: (access: String, refresh: String, type: LoginType)? {
        get {
            return UserDefaults.standard.object(forKey: "token") as? (access: String, refresh: String, type: LoginType)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    
    var isFirstAccess: Bool? {
        
        get {
            return UserDefaults.standard.object(forKey: "isFirstAccess") as? Bool
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isFirstAccess")
        }
    }
}
