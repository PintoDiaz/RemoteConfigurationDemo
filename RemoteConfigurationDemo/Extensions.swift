//
//  Extensions.swift
//  RemoteConfigurationDemo
//
//  Created by Pinto Diaz, Roger on 11/4/20.
//

import UIKit

extension UIView {
    func shadow(opacity: Float = 0.25, offset: CGFloat = 2) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = opacity
    }

    func roundedCorners() {
        self.layer.cornerRadius = 10
    }
}
