//
//  CircularButton.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 29/11/2015.
//
//

import UIKit

class CircularButton: UIButton, CircularViewProtocol {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addTarget(self, action: "rotate", forControlEvents: .TouchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup(layer)
    }

    func rotate() {

        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        UIView.animateWithDuration(0.3) { () -> Void in
            self.transform = CGAffineTransformRotate(self.transform, CGFloat(-M_PI_4))
        }
        
    }
}
