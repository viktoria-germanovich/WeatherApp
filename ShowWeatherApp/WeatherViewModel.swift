//
//  WeatherViewModel.swift
//  ShowWeatherApp
//
//  Created by Виктория Германович on 5.10.22.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewModel {
    var locationManager = CLLocationManager()
    
    //MARK: - get weather data with Alamofire
    func getWeatherWithAlomofire(lat: String, long: String, compeltion: @escaping([String: Any])->()){
        guard let url = URL(string: APIClient.shared.getWeatherDataURL(lat: lat, lon: long)) else
        {
            print ("Could not form url")
            return
        }
        AF.request(url).responseJSON { (response) in
            if let jsonData = response.value as? [String: Any] {
                DispatchQueue.main.async {
                    compeltion(jsonData)
                }
            }
        }
    }
    
    //MARK: - not used. It has been written for testing. Geе weather with URLSession
    func getWeatherWithURLSession(lat: String, long: String){
        let apiKey = APIClient.shared.apiKey
        
        if var urlComponents = URLComponents(string: APIClient.shared.baseURL){
            urlComponents.query = "lat=\(lat)&lon=\(long)&APPID=\(apiKey)"
            guard let url = urlComponents.url else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json: charset=utf-8", forHTTPHeaderField: "Accept")
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                do {
                    guard let weatherData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("the was an error converting data to JSON")
                        return
                    }
                    print(weatherData)
                
                } catch {
                    print("error converting data into JSON")
                }
            }
            
            task.resume()
        }
    }
}

