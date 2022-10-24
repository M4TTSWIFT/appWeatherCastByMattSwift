//
//  ViewController.swift
//  appWeatherCastByMattSwift
//
//  Created by Mac on 20.09.2022.
//

import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController, DetailPresenterDelegate, CLLocationManagerDelegate {
    
    var detail = [WeatherModel]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var currentweatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionImage: UIImageView!
    
    var lat: Double = 50.433334
    var lon: Double = 30.516666
    
//    var lat: Double = 0
//    var lon: Double = 0
    
    private let presenter = DetailPresenter()
    
    //MARK: - ViewDidLoad:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setDelegate(delegate: self)
        print("viewDidLoad: \(lat) + \(lon)")
    }
    
    //MARK: - ViewWillAppear:
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set initial location:
        let initialLocation = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        mapView.centerCoordinate = initialLocation
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

        let placeMarkButton = UIButton(type: .system)
        placeMarkButton.setImage(#imageLiteral(resourceName: "ic_place"), for: .normal)
        placeMarkButton.addTarget(self, action: #selector(placeIconTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: placeMarkButton)]
        
        
        //MARK: - Navigation Bar buttons

    }
    
    @objc func placeIconTapped() {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
        searchVC.selectedLatLonDelegate = self
        let navController = UINavigationController(rootViewController: searchVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
    }
    
    @objc func navigationIconTapped() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
    }
    
    //MARK: - Map View manager and settings:
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)

        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region,
                          animated: true)
        
        navigateLocation(coordinate)
    }
    
    func navigateLocation(_ coordinate: CLLocationCoordinate2D) {
            
            self.lat = coordinate.latitude
            self.lon = coordinate.longitude
            self.presenter.fetchData(lat: self.lat, lon: self.lon)
            setupNavigationBar()
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

//MARK: - Extensions ViewController:

extension ViewController: LatLonProtocol {
    func navigateLatLon(lat: Double, lon: Double) {

    }
    
    func selectedLatLon(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
}
