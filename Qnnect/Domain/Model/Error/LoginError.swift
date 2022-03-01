//
//  LoginError.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/02.
//

import Foundation

enum LoginError: Int, Error {
    case accessTokenExpiration = 500
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case decodingError
    case unknownError
}
