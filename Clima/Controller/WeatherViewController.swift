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
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    var apiManager = APIManager()
    var locationManager = CLLocationManager()
    var forecastWeatherModel : [ForecastWeatherModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupWeatherView()
    }
    private func setupWeatherView() {
        apiManager.delegate = self
        searchTextField.delegate = self
        setupCollectionView()
        
        //set up location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }
    private func setupCollectionView(){
        forecastCollectionView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellWithReuseIdentifier: "ForecastCell")
        forecastCollectionView.dataSource = self
        forecastCollectionView.isHidden = true
        
        //setup layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        forecastCollectionView.collectionViewLayout = layout
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
        forecastCollectionView.setContentOffset(.zero, animated: true)
    }
}

//MARK: -APIManagerDelegate
extension WeatherViewController:APIManagerDelegate{
    func didUpdateWeather(_ weatherModel: WeatherModel, _ forecastResponse: ForecastList) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.1f °C", weatherModel.temperature)
            self.cityLabel.text = weatherModel.cityName
            self.DescriptionLabel.text = weatherModel.description
            self.conditionImageView.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(weatherModel.icon)@2x.png"))
            
            guard !forecastResponse.list.isEmpty else {
                self.forecastCollectionView.isHidden = true
                return
            }
            self.forecastCollectionView.isHidden = false
            self.forecastWeatherModel = forecastResponse.list
            self.forecastCollectionView.reloadData()
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
            
            forecastCollectionView.setContentOffset(.zero, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Get location error: \(error)")
    }
}

//MARK: -CollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastWeatherModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        
        cell.dateLabel.text = forecastWeatherModel[indexPath.row].date
        cell.timeLabel.text = forecastWeatherModel[indexPath.row].time
        cell.tempLabel.text = String(format: "%.1f °C", forecastWeatherModel[indexPath.row].temp)
        cell.Icon.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(forecastWeatherModel[indexPath.row].icon)@2x.png"))
        return cell
    }
    
    
}
