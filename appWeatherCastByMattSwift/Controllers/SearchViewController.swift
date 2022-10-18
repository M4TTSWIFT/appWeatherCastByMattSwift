//
//  SearchViewController.swift
//  appWeatherCastByMattSwift
//
//  Created by Mac on 29.09.2022.
//

import UIKit

protocol LatLonProtocol {
    func selectedLatLon(lat: Double, lon: Double)
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchPresenterDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var cities = [WeatherModel]()
    var filteredCities: [WeatherModel]!
    
    var selectedLatLonDelegate: LatLonProtocol!
    
    private let presenter = SearchPresenter()
    
    var lon: Double = 0
    var lat: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        presenter.setSearchDelegate(delegate: self)
        presenter.fetchInfo()
        filteredCities = cities
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell

        cell.setCells(city: filteredCities[indexPath.row].name, country: filteredCities[indexPath.row].country, index: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lat = filteredCities[indexPath.row].coord.lat
        lon = filteredCities[indexPath.row].coord.lon
    }
    
    func presentCity(city: [WeatherModel]) {
        self.cities = city
    }
    

//    MARK: - Search Bar Config
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCities = []
        
        if searchText == "" {
            filteredCities = cities
        } else {
            for city in cities {
                if city.name.lowercased().contains(searchText.lowercased()) {
                    filteredCities.append(city)
                }
            }
        }
        
      self.tableView.reloadData()
    }

    
//MARK: - setup Navigation Bar
    
    fileprivate func setupNavigationBar() {
    UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(named: "appMainBlue")

    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.backgroundColor = UIColor(named: "appMainBlue")
    navigationController?.navigationBar.barTintColor = UIColor(named: "appMainBlue")
    navigationController?.navigationBar.isTranslucent = false
        
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = UIColor(named: "appMainBlue")
    UINavigationBar.appearance().standardAppearance = appearance

    let searchButton = UIButton(type: .system)
    searchButton.setImage(#imageLiteral(resourceName: "ic_search"), for: .normal)
    searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    
    let dismissButton = UIButton(type: .system)
    dismissButton.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
    dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        
    let searchBarSetup: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.placeholder = "Населенный пункт"
        searchBar.delegate = self
        let emptyImage = UIImage()
        searchBar.setImage(emptyImage, for: .search, state: .normal)
        return searchBar
    }()

        navigationItem.titleView = searchBarSetup

}

@objc func dismissButtonTapped() {
    dismiss(animated: true)
}

@objc func searchButtonTapped() {
    selectedLatLonDelegate?.selectedLatLon(lat: lat, lon: lon)
    dismiss(animated: true)
    }
}

extension SearchViewController: SelectedLatLonProtocol {
    

func fetchLatLon(lat: Double, lon: Double) {
    self.lat = lat
    self.lon = lon
    }
}
