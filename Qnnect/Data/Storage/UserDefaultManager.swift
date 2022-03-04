//
//  AuthUseDefaultManager.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/23.
//

import Foundation



protocol UserDefaultManager: AnyObject {
    var token: Token? { get set }
    var isFirstAccess: Bool? { get set }
    var loginType: LoginType? { get set }
}

final class DefaultUserDefaultManager: UserDefaultManager {
    
    var token: Token? {
        get {
            if let data = UserDefaults.standard.object(forKey: "token") as? Data {
                if let token = try? JSONDecoder().decode(Token.self, from: data) {
                    print("token get : \(token)")
                    return token
                }
            }
            return nil
        }
        
        set {
            if let token = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(token, forKey: "token")
                print("token set : \(String(describing: newValue))")
            }
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
    
    var loginType: LoginType? {
        
        get {
            return LoginType(rawValue: UserDefaults.standard.object(forKey: "LoginType") as? String ?? "")
        }
        
        set {
            UserDefaults.standard.setValue(newValue?.rawValue, forKey: "LoginType")
        }
    }
}
