//
//  String + extension.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//
import UIKit

extension String {
    func localized() -> String{
        return NSLocalizedString(self, comment: "");
    }
}
