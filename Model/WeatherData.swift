//
//  WeatherData.swift
//  Clima
//
//  Created by ccdtruong on 16/9/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Decodable {
    let temp : Float
}

struct Weather : Decodable {
    let id : Int
    let description : String
}
