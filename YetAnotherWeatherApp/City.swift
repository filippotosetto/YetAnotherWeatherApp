//
//  City.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 11/04/2015.
//

import SwiftyJSON
import CoreLocation

struct City {
    let name: String
    let longitude: String
    let latitude: String
    
    let coordinate: CLLocationCoordinate2D
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.longitude = json["coord"]["lon"].stringValue
        self.latitude = json["coord"]["lat"].stringValue
        
        self.coordinate = CLLocationCoordinate2D(latitude: (self.latitude as NSString).doubleValue, longitude: (self.longitude as NSString).doubleValue)
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
        self.longitude = String(format: "%f", arguments: [coordinate.longitude])
        self.latitude = String(format: "%f", arguments: [coordinate.latitude])
    }
    
    init(name: String, longitude: String, latitude: String) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        
        self.coordinate = CLLocationCoordinate2D(latitude: (self.latitude as NSString).doubleValue, longitude: (self.longitude as NSString).doubleValue)
    }
}


extension City: Equatable {}

func ==(lhs: City, rhs: City) -> Bool {
    return lhs.name == rhs.name && lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
}