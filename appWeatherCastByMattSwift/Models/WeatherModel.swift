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
        case country = "country"
        case main = "main"
        case weather = "weather"
        case wind = "wind"
        }
    
        let date: Int?
        let coord: Coordination
        let name: String
        let country: String?
        let main: Daily?
        let weather: [Current]?
        let wind: Wind?
    }
    struct Coordination: Codable {
        let lat: Double
        let lon: Double
        }
        
    struct Daily: Codable {
        
        enum CodingKeys: String, CodingKey {
            case pressure = "pressure"
            case humidity = "humidity"
            case tempMax = "temp_max"
            case tempMin = "temp_min"
        }
        
        let pressure: Int
        let humidity: Int
        let tempMax: Double
        let tempMin: Double
    }
    
    struct Current: Codable {
        let id: Int
        let description: String
            
            var conditionImage: UIImage {
                switch id {
                case 200...232:
                    return (#imageLiteral(resourceName: "ic_white_day_thunder"))
                case 300...321:
                    return (#imageLiteral(resourceName: "ic_white_day_rain"))
                case 500...531:
                    return (#imageLiteral(resourceName: "ic_white_day_shower"))
                case 600...622:
                    return (#imageLiteral(resourceName: "ic_white_night_shower"))
                case 701...781:
                    return (#imageLiteral(resourceName: "ic_white_night_cloudy"))
                case 800:
                    return (#imageLiteral(resourceName: "ic_white_day_bright"))
                case 801...804:
                    return (#imageLiteral(resourceName: "ic_white_day_cloudy"))
                default:
                    return (#imageLiteral(resourceName: "ic_white_night_bright"))
                }
            }
            
        }
        
        struct Wind: Codable {
        let deg: Double
        let speed: Double
            
            ///С направлением есть момент. Иконки сделаны по географическому направлению,
            ///а нам нужно метеорологическое. Южний ветер дует на север (то есть, показывает
            ///на север). Здесь же Южный ветер дизайнер отрисовал с направлением на Юг.
            /// оставил как есть
            
            var conditionOfWind: UIImage {
                switch deg {
            case 1...45:
                return (#imageLiteral(resourceName: "icon_wind_n"))
            case 46...90:
                return (#imageLiteral(resourceName: "icon_wind_ne"))
            case 91...135:
                return (#imageLiteral(resourceName: "icon_wind_e"))
            case 136...180:
                return (#imageLiteral(resourceName: "icon_wind_se"))
            case 181...225:
                return (#imageLiteral(resourceName: "icon_wind_s"))
            case 226...270:
                return (#imageLiteral(resourceName: "icon_wind_ws"))
            case 271...315:
                return (#imageLiteral(resourceName: "icon_wind_w"))
            case 316...360:
                return (#imageLiteral(resourceName: "icon_wind_wn"))
            default:
                print("error")
                return (#imageLiteral(resourceName: "ic_white_day_bright"))
                }
            }
        }
