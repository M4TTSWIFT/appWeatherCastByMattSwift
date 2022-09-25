//
//  WeatherModel.swift
//  appWeatherCastByMattSwift
//
//  Created by Mac on 23.09.2022.
//

import UIKit

    struct WeatherModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case coord = "coord"
        case name = "name"
        case main = "main"
        case weather = "weather"
        case wind = "wind"
        }
    
        let date: Int
        let coord: Coordination
        let name: String
        let main: Daily
        let weather: [Current]
        let wind: Wind
    }
    struct Coordination: Codable {
        let lat: Double
        let lon: Double
        }
        
    struct Daily: Codable {
        
        enum CodingKeys: String, CodingKey {
            case humidity = "humidity"
            case tempMax = "temp_max"
            case tempMin = "temp_min"
        }
        
        let humidity: Int
        let tempMax: Double
        let tempMin: Double
    }
    
        struct Current: Codable {
        let id: Int?
        }
        
        struct Wind: Codable {
        let deg: Int
        let speed: Double
        }
