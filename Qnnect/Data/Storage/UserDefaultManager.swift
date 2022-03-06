//
//  AuthUseDefaultManager.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation



protocol UserDefaultManager: AnyObject {
    var isFirstAccess: Bool? { get set }
    var loginType: LoginType? { get set }
}

final class DefaultUserDefaultManager: UserDefaultManager {
    
    var isFirstAccess: Bool? {
        
        get {
            return UserDefaults.standard.object(forKey: "isFirstAccess") as? Bool
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isFirstAccess")
        }
    }
    
    var loginType: LoginType? {
        
        get {
            return LoginType(rawValue: UserDefaults.standard.object(forKey: "LoginType") as? String ?? "")
        }
        
        set {
            UserDefaults.standard.setValue(newValue?.rawValue, forKey: "LoginType")
        }
    }
}
