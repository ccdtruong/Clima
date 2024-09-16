//
//  APIManager.swift
//  Clima
//
//  Created by ccdtruong on 16/9/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct APIManager {
    var apiUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&"
    var appid = "fa2e7641b493088d4b4a808c143b2c23"
    var cityName = "Hanoi"
    
    mutating func setCityname(_ city : String) {
        cityName = city
    }
    
    func fecthWeather() {
        
        let urlString = createRequestUrl()
        print(urlString)
        performRequest(urlString)
    }
    
    func createRequestUrl() -> String {
        return "\(apiUrl)appid=\(appid)&q=\(cityName)"
    }
    
    func performRequest(_ urlString : String)
    {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let responseData = data {
                    parseJSON(responseData)
                }
            }
            dataTask.resume()
        }
    }
    
    func parseJSON(_ jsonData : Data){
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: jsonData)
            print("\(decodeData.name)-\(decodeData.main.temp)-\(decodeData.weather[0].description)")
        }
        catch{
            print(error)
        }
    }
}
