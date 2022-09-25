//
//  ViewController.swift
//  appWeatherCastByMattSwift
//
//  Created by Mac on 20.09.2022.
//

import UIKit

class ViewController: UIViewController, DetailPresenterDelegate {
    
    var detail = [WeatherModel]()
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var currentweatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionImage: UIImageView!
    
    var lat: Double = 44.34
    var lon: Double = 10.99
    
    private let presenter = DetailPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter.setDelegate(delegate: self)
        presenter.fetchData(lat: lat, lon: lon)
        
    }

    //MARK: - setup Navigation Bar:

    private func setupNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        
        let navigationButton = UIButton(type: .system)
        navigationButton.setImage(#imageLiteral(resourceName: "ic_my_location"), for: .normal)
        navigationButton.addTarget(self, action: #selector(navigationIconTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationButton)
        
        let navigationBarCityLabel = UILabel()
        navigationBarCityLabel.textColor = .white
        navigationBarCityLabel.text = "cityName"
        
        let placeMarkButton = UIButton(type: .system)
        placeMarkButton.setImage(#imageLiteral(resourceName: "ic_place"), for: .normal)
        placeMarkButton.addTarget(self, action: #selector(placeIconTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: placeMarkButton),
                                             UIBarButtonItem(customView: navigationBarCityLabel)
                                            ]
    }
    
    @objc func placeIconTapped() {
        print("Place icon pressed.")
    }
    
    @objc func navigationIconTapped() {
        print("Navigation icon pressed.")
    }
    
    //MARK: - ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // setLabels()
        print(detail)
    }
    
    //MARK: - presentDetail:
    
    func presentDetail(detail: WeatherModel) {
      self.detail = [detail]
    }
    
    //MARK: - setup for current city weather:
    
    private func setLabels() {
       // self.dateLabel.text = "\(self.detail[0].date)"
       // self.tempLabel.text = "\(self.detail[0].main.tempMax ) / \(self.detail[0].main.tempMin)"
    }
    
}

