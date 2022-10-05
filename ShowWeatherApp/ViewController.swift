//
//  ViewController.swift
//  ShowWeatherApp
//
//  Created by Виктория Германович on 5.10.22.
//

import UIKit

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }

    func parseJsonWithSwifty(data:[String: Any]){

        let jsonData = JSON(data)
        if let humidity = jsonData["main"]["humidity"].int{
            humidityLabel.text = "\(String(humidity))%"
        }

        if let temp = jsonData["main"]["temp"].double{
            tempratureLabel.text = "\(String(Int(temp-273.15)))\u{2103}"
        }

        if let speed = jsonData["wind"]["speed"].double{
            windSpeedLabel.text = "\(String(speed)) m/s"
        }

        if let city = jsonData["name"].string{
            cityNameLabel.text = city
        }

    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let viewModel = WeatherViewModel()
        if let location = locations.first{
            let latitude = String(location.coordinate.latitude)
            let longtitude = String(location.coordinate.longitude)
            viewModel.getWeatherWithAlomofire(lat: latitude, long: longtitude) { weather in
                self.parseJsonWithSwifty(data: weather)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        
        case .denied, .restricted:
            let alertController = UIAlertController(title: "Location Access Disabled", message: "Weather App needs your location to give a weather forecast. Open your settings to change authorization?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel ){
                (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open", style: .default){
                (action) in
                if let url = URL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            alertController.addAction(openAction)
            present(alertController, animated: true, completion: nil)
            
            break
            
            default:
            return
        }
    }
}
