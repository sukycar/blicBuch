//
//  UIView + device.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 26.2.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func getDeviceType() -> DeviceType {
        #if os(OSX)
        print("macOS")
        #elseif os(watchOS)
        print("watchOS")
        #elseif os(tvOS)
        print("tvOS")
        #elseif os(iOS)
        #if targetEnvironment(macCatalyst)
        return DeviceType.macCatalyst
        #else
        let currentDevice = UIDevice.current.userInterfaceIdiom
        if currentDevice != .pad{
            return DeviceType.iPhone
        } else {
            return DeviceType.iPad
        }
        #endif
        #endif
    }
}

enum DeviceType {
    case iPhone
    case iPad
    case macCatalyst
}
