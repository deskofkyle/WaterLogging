//
//  UIFont+Rounded.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

// Citation: https://stackoverflow.com/a/57961002
//
// I researched how to use the SF-Rounded San Francisco Typeface
// The below extension is losely based on the technique described in the cited link.

extension UIFont {
    /// Provides a SF-Rounded San Francisco Typeface of the given size and weight.
    /// It will default to UIFont.systemFont is rounded typeface is not available.
    static func roundedFont(with size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let defaultFont = UIFont.systemFont(ofSize: size,
                                            weight: weight)
        
        if let descriptor = defaultFont.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor,
                          size: size)
        } else {
            return defaultFont
        }
    }
}
