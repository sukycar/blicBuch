//
//  RemoteResourceError.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

enum RemoteResourceError: LocalizedError {
    case noInternetConnection
    case timeout
    case server(statusCode: Int)
    case request(statusCode: Int)
    case invalidCredentials
    case invalidResponse
    case invalidJson
    case generic
    case descriptive(description: String)
    case uploadFailed
    case loginRequired

    public var errorDescription: String? {
        switch self {
        case .noInternetConnection: return "No internet connection!"
        case .timeout: return "Request timeout!"
        case let .server(statusCode): return "Server error with status code:\(statusCode)"
        case let .request(statusCode): return "Request error with status code:\(statusCode)"
        case .invalidCredentials: return "nvalid credentials!"
        case .invalidResponse: return "Invalid response!"
        case .generic: return "Looks like there’s a problem. We’re working to fix it, so try again later."
        case .invalidJson: return "JSON parsing failed!"
        case let .descriptive(description): return description
        case .uploadFailed: return "JSON parsing failed!"
        case .loginRequired:
            let firstString = "This operation is sensitive and requires recent authentication."
            let secondString = "Please log out and then log in again before retrying this request."
            let loginString = firstString + secondString
            return loginString
        }
    }
}
