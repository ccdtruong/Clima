//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var apiManager = APIManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        apiManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

//MARK: -UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type something here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            apiManager.createRequestUrl(city: city)
        }
        apiManager.fecthWeather()
        textField.text = ""
    }
}

//MARK: -APIManagerDelegate
extension WeatherViewController:APIManagerDelegate{
    func didUpdateWeather(_ weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.1f °C", weatherModel.temperature)
            self.cityLabel.text = weatherModel.cityName
            self.DescriptionLabel.text = weatherModel.description
            self.conditionImageView.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(weatherModel.icon)@2x.png"))
        }
    }
    
    func didFailWithError(_ error: any Error) {
        print(error)
    }
}

//MARK: -CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            apiManager.createRequestUrl(coordinate: location.coordinate)
            apiManager.fecthWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Get location error: \(error)")
    }
}

