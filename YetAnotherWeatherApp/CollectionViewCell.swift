//
//  CollectionViewCell.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 23/09/2015.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    var weather: Weather {
        set {
            temperatureLabel.text = "\(newValue.temperature)"
            weatherImage.image = UIImage(named: newValue.icon)
            weatherImage.image = weatherImage.image?.imageWithRenderingMode(.AlwaysTemplate)
            weatherImage.tintColor = UIColor.blackColor()
            dayLabel.text = newValue.day.getDayOfWeek()
        }
        get {
            return self.weather
        }
    }
}

extension CollectionViewCell: NibLoadableView {
}