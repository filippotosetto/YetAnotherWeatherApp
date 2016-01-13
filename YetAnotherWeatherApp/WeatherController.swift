//
//  ContainerView.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 11/01/2016.
//
//

import UIKit
import CoreLocation

class WeatherController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var curveView: CurveView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var city: City? {
        didSet {
            if let c = city {
                getWeatherForCurrentLocation(c.coordinate)
            }
        }
    }
    
    var forecast: [Weather]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var currentWeather: Weather {
        set {
            self.temperatureLabel.text = "\(newValue.temperature)"
            self.cityLabel.text = newValue.city.name
            self.iconImage.image = UIImage(named: newValue.icon)
            self.iconImage.image = self.iconImage.image?.imageWithRenderingMode(.AlwaysTemplate)
            self.iconImage.tintColor = UIColor.blackColor()
        }
        get {
            return self.currentWeather
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CollectionViewCell.self)
        
        view.layer.borderColor = UIColor.blackColor().CGColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 5.0
    }
    
    private func getWeatherForCurrentLocation(coordinate: CLLocationCoordinate2D) {
        Weather.getCurrentWeather(coordinate) { self.currentWeather = $0 }
        Weather.getDailyForecast(coordinate) { self.forecast = $0 }
        Weather.getForecast(coordinate) {
            var data = [Weather]()
            for (index, item) in $0.enumerate() where index < 8 {
                data.append(item)
            }
            
            self.curveView.weather = data
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension WeatherController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast != nil ? forecast!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.weather = forecast![indexPath.row]
        return cell
    }
}



