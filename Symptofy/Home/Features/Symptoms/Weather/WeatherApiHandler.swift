//
//  WeatherApiHandler.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/30/23.
//

import Foundation
import MapKit
import CoreLocation

class WeatherApiManager: NSObject {
    
    let locationManager = CLLocationManager()
    private static let apiManager = WeatherApiManager()
    
    static func sharedInstace() -> WeatherApiManager {
        return apiManager
    }
    
    func getTemparature(lat: String, lon: String, completion: @escaping (Double) -> Void) {
        let APIUrl = NSURL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=816235944789051f18737baf232be371&units=imperial")
        var request = URLRequest(url:APIUrl! as URL)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                return
            }

            guard let responseData = data else {
                return
            }

            do {
                let weatherData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                let tempInFahrenheit = ((weatherData as? NSDictionary)?["main"] as? NSDictionary)?["temp"] as? Double
                completion(tempInFahrenheit ?? 0.0)
            } catch  {
                return
            }
        })
        dataTask.resume()
    }
}

extension WeatherApiManager {
    func getLocation(delegate: CLLocationManagerDelegate) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = delegate
    }
}
