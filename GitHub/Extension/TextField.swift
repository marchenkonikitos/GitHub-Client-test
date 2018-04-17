//
//  TextField.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 02.04.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func shakeAnimation(duration: Double, repeatCount: Float) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
}
