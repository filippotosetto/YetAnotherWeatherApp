//
//  DataManager.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 08/01/2016.
//
//

import Foundation
import CoreLocation

class DataManager {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let citiesConstant = "CITIES"
    
    func addNewCity(city: City) -> [City] {
        var cities = getCitiesList()
        cities.append(city)
        
        setCities(cities)
        
        return getCitiesList()
    }
    
    func removeCity(city: City) -> [City] {
        var cities = getCitiesList()
        cities.removeObject(city)
        
        setCities(cities)
        
        return getCitiesList()
    }
    
    func getCitiesList() -> [City] {
        guard let cities = defaults.objectForKey(citiesConstant) else {
            return [City]()
        }
        return mapDictionaryToCity(cities as! [[String:String]])
    }
    
    private func setCities(cities: [City]) {
        defaults.setObject(mapCityToDictionary(cities), forKey: citiesConstant)
        defaults.synchronize()
    }
}

// MARK: Mapping method
extension DataManager {
    private func mapCityToDictionary(cities: [City]) -> [[String:String]] {
        return cities.map { ["name" : $0.name, "longitude" : $0.longitude, "latitude" : $0.latitude] }
    }
    
    private func mapDictionaryToCity(dictionary: [[String: String]]) -> [City] {
        return dictionary.map { City(name: $0["name"]!, longitude: $0["longitude"]!, latitude: $0["latitude"]! ) }
    }
}