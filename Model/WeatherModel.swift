//
//  WeatherModel.swift
//  Clima
//
//  Created by ccdtruong on 17/9/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    let cityName : String
    let temperature : Double
    let description : String
    let icon : String
    
    enum CodingKeys: String, CodingKey {
        case name
        case main
        case weather
    }
    
    enum MainKeys: String, CodingKey {
        case temp
    }
    
    enum WeatherKeys: String, CodingKey {
        case description
        case icon
    }
    
    init(from decoder: any Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        //Decode city name
        cityName = try data.decode(String.self, forKey: .name)//Decode city name
        print("1")
        let main = try data.nestedContainer(keyedBy: MainKeys.self, forKey: .main)//Decode main keys
        temperature = try main.decode(Double.self, forKey: .temp)//Decode temp in main keys
        print("2")
        var weatherArray = try data.nestedUnkeyedContainer(forKey: .weather)//Decode weather array
        let weather = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)//Get first element in weather array
        //Decode des and icon in weather keys
        print("3")
        description = try weather.decode(String.self, forKey: .description)
        icon = try weather.decode(String.self, forKey: .icon)
        print("4")
    }
}
