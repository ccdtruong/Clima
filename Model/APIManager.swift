//
//  APIManager.swift
//  Clima
//
//  Created by ccdtruong on 16/9/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol APIManagerDelegate {
    func didUpdateWeather (_ weatherModel : WeatherModel)
    func didFailWithError(_ error: Error)
}

enum FecthError: Error{
    case urlError
    case responseError
    case decodeError
}

struct APIManager {
    var apiUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&lang=vi&"
    var appid = "fa2e7641b493088d4b4a808c143b2c23"
    
    var urlString = ""
    var delegate : APIManagerDelegate?
    
    func fecthWeather() {
//        performRequest(urlString)
        Task{
            do{
                let dataModel = try await fecthWeatherData(from: urlString, responeType: WeatherModel.self)
                delegate?.didUpdateWeather(dataModel)
            }
            catch{
                delegate?.didFailWithError(error)
            }
        }
    }
    
    mutating func createRequestUrl(city cityName : String) {
        if let validCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            urlString = "\(apiUrl)appid=\(appid)&q=\(validCityName)"
        }
    }
    
    mutating func createRequestUrl(coordinate : CLLocationCoordinate2D) {
        urlString = "\(apiUrl)appid=\(appid)&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
    }
 
    func fecthWeatherData<T: Decodable> (from urlString : String, responeType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw FecthError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FecthError.responseError
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        catch{
            throw FecthError.decodeError
        }
        
        
    }
}
