//
//  Presenter.swift
//  appWeatherCastByMattSwift
//
//  Created by Mac on 24.09.2022.
//

import UIKit

protocol DetailPresenterDelegate: Any {
    func presentDetail(detail: WeatherModel)
}

typealias DetailDelegate = DetailPresenterDelegate & UIViewController

class DetailPresenter {
    
    weak var delegate: DetailDelegate?
    
    public func fetchData(lat: Double, lon: Double) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=4da5b063c90b928b08d26d36094897e9&units=metric") else {
            return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , _, error in
            guard let data = data, error == nil else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                self?.delegate?.presentDetail(detail: weatherData)
                print(weatherData)
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    public func setDelegate(delegate: DetailDelegate) {
        self.delegate = delegate
    }
    
}

