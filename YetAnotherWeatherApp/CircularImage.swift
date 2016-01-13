//
//  CircularImage.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 28/09/2015.
//

import UIKit

class CircularImage: UIImageView, CircularViewProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup(layer)
    }
}
