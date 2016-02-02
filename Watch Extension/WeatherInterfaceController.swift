//
//  WeatherInterfaceController.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 14/01/2016.
//
//

import WatchKit
import Foundation
import CoreLocation


class WeatherInterfaceController: WKInterfaceController {
    
    @IBOutlet var cityLabel: WKInterfaceLabel!
    @IBOutlet var weatherIcon: WKInterfaceImage!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    
    let locationManager = CLLocationManager()
    
    
    var currentWeather: Weather? {
        didSet {
            if let weather = currentWeather {
                self.temperatureLabel.setText("\(weather.temperature)")
                self.cityLabel.setText(weather.city.name)
                self.weatherIcon.setImage(UIImage(named: weather.icon))
                //                self.weatherIcon.image = self.iconImage.image?.imageWithRenderingMode(.AlwaysTemplate)
                self.weatherIcon.setTintColor(UIColor.whiteColor())
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setupLocationManager()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    
}

extension WeatherInterfaceController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        guard status == .AuthorizedWhenInUse else {
            return
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        Weather.getCurrentWeather(locations[0].coordinate) { (weather) -> Void in
            self.currentWeather = weather
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
}
