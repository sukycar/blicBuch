//
//  ErrorView.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

enum ErrorType {
    case error
    case remoteError
}

struct ErrorView {
    let title: String?
    let message: String?
    let type: ErrorType
}

extension RemoteResourceError {
    func toErrorView() -> ErrorView {
        switch self {
        default:
            return ErrorView(title: "Network Error", message: self.localizedDescription, type: .remoteError)
        }
    }
}
