//
//  APIClient.swift
//  WeatherApp
//
//  Created by Виктория Германович on 12.12.21.
//

import Foundation

//MARK: - API open weather api client
final class APIClient {
    static let shared: APIClient = APIClient()
    
    var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist"), let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file APIKey.plist")
        }
        return plist.object(forKey: "API_KEY") as! String
    }
    
    let baseURL: String = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherDataURL(lat: String, lon: String)->String {
        let url: String = "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        return url
    }
}

