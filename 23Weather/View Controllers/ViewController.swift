//
//  ViewController.swift
//  23Weather
//
//  Created by Roman Oliinyk on 30.05.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var networkWeatherManager = NetworkWeatherManager()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        lm.delegate = self
        return lm
    }()
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDescriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    var cityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        //        networkWeatherManager.fetchCurrentWeater(for: "Kyiv") { currentWeather in
        //            self.updateInterfaceWith(weather: currentWeather)
        //        }
    }
    
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        presentSearchAlertController(with: "Enter city name", message: "") { (city) in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
            self.networkWeatherManager.onCompletion = { currentWeather in
                self.updateInterfaceWith(weather: currentWeather)
            }
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.title = weather.name
            self.temperatureLabel.text = weather.temperatureString + "º"
            self.feelsLikeLabel.text = weather.feelsLikeString + "º"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemNameString)
            self.temperatureDescriptionLabel.text = weather.description
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinates(latitude: latitude, longitude: longitude))
        networkWeatherManager.onCompletion = { currentWeather in
            self.updateInterfaceWith(weather: currentWeather)
            
        }
    }
}
