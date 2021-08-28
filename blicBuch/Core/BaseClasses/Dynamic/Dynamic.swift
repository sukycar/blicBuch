//
//  Dynamic.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

class Dynamic<T> {
    
    // MARK: - Typealias
    
    typealias Listener = (T) -> Void
    
    // MARK: - Vars & Lets
    
    var listener: Listener?
    var value: T {
        didSet {
            self.fire()
        }
    }
    
    // MARK: - Initialization
    
    init(_ value: T) {
        self.value = value
    }
    
    // MARK: - Public func
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    // MARK: - Fire
    
    internal func fire() {
        self.listener?(value)
    }
    
}
