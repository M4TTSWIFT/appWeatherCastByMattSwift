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
    
    var lat: Double = 50.433334
    var lon: Double = 30.516666
    
    private let presenter = DetailPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNavigationBar()
        presenter.setDelegate(delegate: self)
        //presenter.fetchData(lat: lat, lon: lon)
        print("viewDidLoad: \(lat) + \(lon)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.fetchData(lat: lat, lon: lon)
        setupNavigationBar()
        print("VWA \(lat) and \(lon)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
    }

    //MARK: - setup Navigation Bar:

    fileprivate func setupNavigationBar() {

        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(named: "appMainBlue")

        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "appMainBlue")
        UINavigationBar.appearance().standardAppearance = appearance
        
        let navigationButton = UIButton(type: .system)
        navigationButton.setImage(#imageLiteral(resourceName: "ic_my_location"), for: .normal)
        navigationButton.addTarget(self, action: #selector(navigationIconTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navigationButton)
        
//        let navigationBarCityLabel = UILabel()
//        navigationBarCityLabel.textColor = .white
//        navigationBarCityLabel.text = "\(detail[0].name)"
        
        let placeMarkButton = UIButton(type: .system)
        placeMarkButton.setImage(#imageLiteral(resourceName: "ic_place"), for: .normal)
        placeMarkButton.addTarget(self, action: #selector(placeIconTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: placeMarkButton),
                                           //  UIBarButtonItem(customView: navigationBarCityLabel)
                                            ]
            
    }
    
    @objc func placeIconTapped() {
       // performSegue(withIdentifier: "searchViewController", sender: nil)
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
        searchVC.selectedLatLonDelegate = self
        let navController = UINavigationController(rootViewController: searchVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    @objc func navigationIconTapped() {
        print("Navigation icon pressed.")
    }
    
    //MARK: - presentDetail:
    
    func presentDetail(detail: WeatherModel) {
        self.detail = [detail]
        setCurrentCityWeatherData()
        print(self.detail.count)
    }
    
    //MARK: - setup for current city weather:
    
    private func setCurrentCityWeatherData() {
        DispatchQueue.main.sync {
            
            // Navigation title Currect city name tag:
            
            let navigationBarCityLabel = UILabel()
            navigationBarCityLabel.textColor = .white
            navigationBarCityLabel.text = "\(detail[0].name)"
            navigationItem.leftBarButtonItems?.append(UIBarButtonItem(customView: navigationBarCityLabel))
            
            // Date organize:
            
            if let timeResult = (self.detail[0].date as? Int) {
                let date = Date(timeIntervalSince1970: TimeInterval(timeResult))
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.none
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeZone = .current
                
                var currentWeekday = dateFormatter.weekdaySymbols[Calendar.current
                    .component(.weekday, from: Date()) - 1]
                switch currentWeekday {
                case "понедельник":
                    currentWeekday = "ПН"
                case "вторник":
                    currentWeekday = "ВТ"
                case "среда":
                    currentWeekday = "СР"
                case "четверг":
                    currentWeekday = "ЧТ"
                case "пятница":
                    currentWeekday = "ПТ"
                case "суббота":
                    currentWeekday = "СБ"
                case "воскресенье":
                    currentWeekday = "ВС"
                default:
                    break
                }

                let format = DateFormatter.dateFormat(
                    fromTemplate: "dMMMM", options:0, locale:NSLocale.current)
                    dateFormatter.dateFormat = format
                let localDate = dateFormatter.string(from: date)
                
                self.dateLabel.text = "\(currentWeekday), \(localDate)"
            }
            
            // Other weather parameters:
            
            self.currentweatherImage.image = self.detail[0].weather![0].conditionImage
            self.tempLabel.text = "\(Int(self.detail[0].main!.tempMax))º / \(Int(self.detail[0].main!.tempMin))º"
            self.humidityLabel.text = "\(self.detail[0].main!.humidity)%"
            self.windLabel.text = "\(Int(self.detail[0].wind!.speed))м/сек"
            self.windDirectionImage.image = self.detail[0].wind?.conditionOfWind
        }
    }
}

extension ViewController: LatLonProtocol {
    func selectedLatLon(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
}
