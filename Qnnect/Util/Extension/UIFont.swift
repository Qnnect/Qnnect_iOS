//
//  File.swift
//  Qnnect
//
//  Created by 재영신 on 2022/02/14.
//

import UIKit


extension UIFont {
    
    // MARK: - IM_Hyemin
    public enum IM_HyeminType{
        case bold
        case regular
        
        var name: String {
            switch self {
            case .bold:
                return "IMHyemin-Bold"
            case .regular:
                return "IMHyemin-Regular"
            }
        }
    }
    
    static func IM_Hyemin(_ type: IM_HyeminType, size: CGFloat) -> UIFont {
        return UIFont(name: type.name, size: size)!
    }
    
//    // MARK: - NotoSans
//    public enum NotoSansType {
//        case bold
//        case medium
//        case regular
//
//        var name: String {
//            switch self {
//            case .bold:
//                return "NotoSansCJKkr-Bold"
//            case .medium:
//                return "NotoSansCJKkr-Medium"
//            case .regular:
//                return "NotoSansCJKkr-Regular"
//            }
//        }
//    }
//
//    static func NotoSans(_ type: NotoSansType, size: CGFloat) -> UIFont {
//        return UIFont(name: type.name, size: size)!
//    }
    
    // MARK: - Roboto
    public enum RobotoType {
        case regular
        
        var name: String {
            switch self {
            case .regular:
                return "Roboto-Regular"
            }
        }
    }
    
    static func Roboto(_ type: RobotoType, size: CGFloat) -> UIFont {
        return UIFont(name: type.name, size: size)!
    }
    
    // MARK: - BM_JUA
    static func BM_JUA(size: CGFloat) -> UIFont {
        return UIFont(name: "BMJUA", size: size)!
    }
}
