//
//  UIColor+Random.swift
//  Taboola SDK Swift Sample
//
//  Created by Roman Slyepko on 3/13/19.
//  Copyright © 2019 Taboola LTD. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var random: UIColor {
        // 0.5 to 1.0 to keep away from very bright and dark
        return UIColor(hue: .random(in: 0...1), saturation: .random(in: 0.5...1), brightness: .random(in: 0.5...1), alpha: 1.0)
    }
}
