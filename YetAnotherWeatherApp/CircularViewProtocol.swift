//
//  CircularViewProtocol.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 10/11/2015.
//

import UIKit

protocol CircularViewProtocol {
    func setup(layer: CALayer)
}

extension CircularViewProtocol {
    func setup(layer: CALayer) {
        layer.cornerRadius = layer.frame.width / 2.0
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 3.0
    }
}
