//
//  MainViewController.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 27/07/2015.

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var plusButton: CircularButton!
    
    let locationManager = CLLocationManager()
    
    var cities = [City]() {
        didSet {
            var counter = 0
            
            scrollView.subviews.forEach({ $0.removeFromSuperview() })
            
            for city in cities {
                let weatherController = storyboard!.instantiateViewControllerWithIdentifier("WeatherController") as! WeatherController
                weatherController.view.x = view.frame.width * CGFloat(counter)
                weatherController.city = city
                
                addChildViewController(weatherController)
                scrollView.addSubview(weatherController.view)
                weatherController.didMoveToParentViewController(self)
                
                counter += 1
            }
            
            self.scrollView.contentSize = CGSizeMake(CGFloat(counter) * view.frame.width, view.frame.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        cities = DataManager().getCitiesList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MainViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        guard NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil else {
            fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        guard status == .AuthorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        self.cities.insert(City(name: "", coordinate: locations[0].coordinate), atIndex: 0)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}

