//
//  ForecastWeatherModel.swift
//  Clima
//
//  Created by ccdtruong on 1/10/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct ForecastWeatherModel: Decodable{
    let date : String
    let time : String
    let icon : String
    let temp : String
    
    enum CodingKeys : String, CodingKey{
        case dateTime = "dt"
        case main
        case weather
    }
    
    enum MainKeys : String, CodingKey {
        case temp
    }
    
    enum WeatherKeys : String, CodingKey {
        case icon
    }
    init(from decoder: any Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        let timeStamp = try data.decode(Int.self, forKey: .dateTime)// get timeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))//Convert to human date
        // format for hour
        let hourFormatted = DateFormatter()
        hourFormatted.dateFormat = "HH:mm"
        time = hourFormatted.string(from: date)
        //format for date
        let dateFormatted = DateFormatter()
        dateFormatted.dateFormat = "dd/MM"
        self.date = dateFormatted.string(from: date)
        //Decode icon from first element weather array
        var weatherArray = try data.nestedUnkeyedContainer(forKey: .weather)
        let weather = try weatherArray.nestedContainer(keyedBy: WeatherKeys.self)
        icon = try weather.decode(String.self, forKey: .icon)
        //Decode temp
        let main = try data.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temp = try main.decode(String.self, forKey: .temp)
    }
}
