//
//  APIManager.swift
//  Clima
//
//  Created by ccdtruong on 16/9/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
protocol APIManagerDelegate {
    func didUpdateWeather (_ weatherModel : WeatherModel)
    func didFailWithError(_ error: Error)
}
struct APIManager {
    var apiUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&lang=vi&"
    var appid = "fa2e7641b493088d4b4a808c143b2c23"
    var cityName = "Hanoi"
    
    var delegate : APIManagerDelegate?
    
    mutating func setCityname(_ city : String) {
        if let validCityName = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            cityName = validCityName
        }
        else {
            cityName = ""
        }
    }
    
    func fecthWeather() {
        
        let urlString = createRequestUrl()
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
                    delegate?.didFailWithError(error!)
                    return
                }
                
                if let responseData = data {
                    if let weatherModel = parseJSON(responseData) {
                        delegate?.didUpdateWeather(weatherModel)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func parseJSON(_ jsonData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: jsonData)
            let id = decodeData.weather[0].id
            let cityName = decodeData.name
            let temp = decodeData.main.temp
            
            return  WeatherModel(id: id, cityName: cityName, temperature: temp)
        }
        catch{
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
