//
//  BaseViewModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import Combine

enum ViewModelState {
    case idle
    case loading
    case finishedLoading
    case error(ErrorView)
}

protocol BaseViewModelProtocol {
    var isLoaderHidden: Dynamic<Bool> { get set }
    var error: Dynamic<CustomError?> { get set }
}

class BaseViewModel: NSObject, ObservableObject {
    var isLoaderHidden: Dynamic<Bool> = Dynamic(true)
    var error: Dynamic<CustomError?> = Dynamic(nil)
}
