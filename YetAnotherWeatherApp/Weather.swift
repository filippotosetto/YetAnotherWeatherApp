//
//  Weather.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 13/04/2015.
//

import Foundation
import SwiftOpenWeatherMapAPI
import SwiftyJSON
import CoreLocation

struct Weather {
    
    var city: City
    let temperature: Int
    let maxTemperature: Int
    let minTemperature: Int
    let icon: String
    let day: NSDate
    
    init(json: JSON) {
        self.city = City(json: json)
        self.temperature = json["main"]["temp"].intValue
        self.maxTemperature = json["main"]["temp_max"].intValue
        self.minTemperature = json["main"]["temp_min"].intValue
        self.icon = json["weather"].array![0]["icon"].stringValue
        self.day = NSDate(timeIntervalSince1970: json["dt"].doubleValue)
    }

    init(json: JSON, city: City) {
        self.city = city
        self.temperature = json["temp"]["day"].intValue
        self.maxTemperature = json["temp"]["max"].intValue
        self.minTemperature = json["temp"]["min"].intValue
        self.icon = json["weather"].array![0]["icon"].stringValue
        self.day = NSDate(timeIntervalSince1970: json["dt"].doubleValue)
    }
    
    static func getCurrentWeather(coordinates: CLLocationCoordinate2D, data: (Weather) -> Void) {
        let apiMgr = WAPIManager(apiKey: apiKey, temperatureFormat: .Celsius, lang: .English)
        apiMgr.temperatureFormat = TemperatureFormat.Celsius
        apiMgr.language = Language.English
        apiMgr.currentWeatherByCoordinatesAsJson(coordinates) { data(Weather(json: $0)) }
    }
    
    static func getDailyForecast(coordinates: CLLocationCoordinate2D, data: ([Weather]) -> Void) {
        WAPIManager(apiKey: apiKey, temperatureFormat: .Celsius).dailyForecastWeatherByCoordinatesAsJson(coordinates) { (json) -> Void in
            let city = City(json: json)
            data(json["list"].array!.map() { Weather(json: $0, city: city) })
        }
    }
    
    static func getForecast(coordinates: CLLocationCoordinate2D, data: ([Weather]) -> Void) {
        WAPIManager(apiKey: apiKey, temperatureFormat: .Celsius).forecastWeatherByCoordinatesAsJson(coordinates) { (json) -> Void in
            let city = City(json: json["city"])
            data(json["list"].array!.map() {
                var weather = Weather(json: $0)
                weather.city = city
                return weather
            })
        }
    }

}
