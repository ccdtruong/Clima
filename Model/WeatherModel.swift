//
//  WeatherModel.swift
//  Clima
//
//  Created by ccdtruong on 17/9/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let id : Int
    let cityName : String
    let temperature : Float
    
    var temperatureToString : String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionIconName : String {
        switch id {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }

    }
}
